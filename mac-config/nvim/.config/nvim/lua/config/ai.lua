local M = {}

local default_provider = "claude"
local state_file = vim.fn.stdpath("state") .. "/ai-provider"

local codex_job = {}
local ide_context_server = nil
local ide_context_clients = {}
local ide_context_tmpdir = nil

-- ---------------------------------------------------------------------------
-- Codex IDE IPC server (Unix domain socket)
--
-- OpenAI's `codex` CLI looks for `$TMPDIR/codex-ipc/ipc-{uid}.sock` and speaks
-- a length-prefixed JSON protocol over it. claudecode.nvim / codex.nvim use a
-- different WebSocket+lockfile protocol that the real codex CLI does not
-- understand — that's why /ide says "IDE context could not be enabled" when
-- you rely on codex.nvim. We implement the actual protocol here.
-- ---------------------------------------------------------------------------

local function uid()
	local result = vim.fn.systemlist({ "id", "-u" })
	return result and result[1] or nil
end

local function u32_le(value)
	return string.char(
		value % 256,
		math.floor(value / 256) % 256,
		math.floor(value / 65536) % 256,
		math.floor(value / 16777216) % 256
	)
end

local function read_u32_le(bytes)
	local b1, b2, b3, b4 = string.byte(bytes, 1, 4)
	return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
end

local function descriptor(path)
	return {
		label = vim.fn.fnamemodify(path, ":t"),
		path = vim.fn.fnamemodify(path, ":."),
		fsPath = path,
	}
end

local function cursor_range()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = math.max(cursor[1] - 1, 0)
	local character = math.max(cursor[2], 0)
	return {
		start = { line = line, character = character },
		["end"] = { line = line, character = character },
	}
end

local function visual_range()
	local mode = vim.fn.mode()
	if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
		return cursor_range(), ""
	end

	local start_pos = vim.fn.getpos("v")
	local end_pos = vim.fn.getcurpos()
	local start_line, start_col = start_pos[2], start_pos[3]
	local end_line, end_col = end_pos[2], end_pos[3]

	if start_line > end_line or (start_line == end_line and start_col > end_col) then
		start_line, end_line = end_line, start_line
		start_col, end_col = end_col, start_col
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	return {
		start = { line = start_line - 1, character = math.max(start_col - 1, 0) },
		["end"] = { line = end_line - 1, character = math.max(end_col - 1, 0) },
	},
		table.concat(lines, "\n")
end

local function active_file()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" or vim.fn.filereadable(path) == 0 then
		return nil
	end
	local range, selection = visual_range()
	return vim.tbl_extend("force", descriptor(path), {
		selection = range,
		activeSelectionContent = selection,
		selections = {},
	})
end

local function open_tabs()
	local tabs = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[bufnr].buflisted then
			local path = vim.api.nvim_buf_get_name(bufnr)
			if path ~= "" and vim.fn.filereadable(path) == 1 then
				tabs[#tabs + 1] = descriptor(path)
			end
		end
	end
	return tabs
end

function M.codex_ide_context_tmpdir()
	if ide_context_tmpdir then
		return ide_context_tmpdir
	end

	local run_dir = vim.fn.stdpath("run")
	if run_dir == "" or run_dir == nil then
		run_dir = (vim.uv.os_tmpdir() or vim.env.TMPDIR or "/tmp") .. "/nvim-" .. tostring(vim.uv.os_getpid())
	end

	ide_context_tmpdir = run_dir .. "/codex-ide"
	vim.fn.mkdir(ide_context_tmpdir, "p")
	pcall(vim.fn.setfperm, ide_context_tmpdir, "rwx------")
	return ide_context_tmpdir
end

function M.codex_ide_context_socket_path()
	local current_uid = uid()
	if not current_uid then
		return nil
	end
	return M.codex_ide_context_tmpdir() .. "/codex-ipc/ipc-" .. current_uid .. ".sock"
end

local function write_frame(client, message)
	local payload = vim.json.encode(message)
	client:write(u32_le(#payload) .. payload)
end

local function ide_context_response(request)
	return {
		type = "response",
		requestId = request.requestId,
		resultType = "success",
		method = "ide-context",
		handledByClientId = "nvim-client",
		result = {
			type = "broadcast",
			ideContext = {
				activeFile = active_file(),
				openTabs = open_tabs(),
			},
		},
	}
end

local function handle_ide_context_message(client, message)
	if message.type == "request" and message.method == "ide-context" then
		write_frame(client, ide_context_response(message))
	elseif message.type == "client-discovery-request" and message.requestId then
		write_frame(client, {
			type = "client-discovery-response",
			requestId = message.requestId,
			response = { canHandle = true },
		})
	elseif message.type == "request" and message.requestId then
		write_frame(client, {
			type = "response",
			requestId = message.requestId,
			resultType = "error",
			error = "no-handler-for-request",
		})
	end
end

local function close_client(client)
	ide_context_clients[client] = nil
	pcall(function()
		client:read_stop()
	end)
	pcall(function()
		client:close()
	end)
end

local function start_client(client)
	ide_context_clients[client] = true
	local buffer = ""

	client:read_start(function(err, chunk)
		if err or not chunk then
			close_client(client)
			return
		end

		buffer = buffer .. chunk
		while #buffer >= 4 do
			local length = read_u32_le(buffer)
			if #buffer < 4 + length then
				return
			end

			local payload = buffer:sub(5, 4 + length)
			buffer = buffer:sub(5 + length)

			local ok, message = pcall(vim.json.decode, payload)
			if ok and type(message) == "table" then
				vim.schedule(function()
					if ide_context_clients[client] then
						handle_ide_context_message(client, message)
					end
				end)
			end
		end
	end)
end

function M.start_codex_ide_context_server()
	if ide_context_server then
		return
	end

	local socket_path = M.codex_ide_context_socket_path()
	if not socket_path then
		return
	end

	local socket_dir = vim.fn.fnamemodify(socket_path, ":h")
	vim.fn.mkdir(socket_dir, "p")
	pcall(vim.fn.setfperm, socket_dir, "rwx------")

	local server = vim.uv.new_pipe(false)
	local ok, err = server:bind(socket_path)

	if not ok then
		server:close()
		vim.notify(string.format("Codex IDE socket unavailable: %s", err), vim.log.levels.WARN)
		return
	end

	local listen_ok, listen_err = server:listen(16, function(listen_callback_err)
		if listen_callback_err then
			vim.schedule(function()
				vim.notify(string.format("Codex IDE server error: %s", listen_callback_err), vim.log.levels.WARN)
			end)
			return
		end

		local client = vim.uv.new_pipe(false)
		server:accept(client)
		start_client(client)
	end)

	if not listen_ok then
		server:close()
		pcall(vim.fn.delete, socket_path)
		vim.notify(string.format("Codex IDE server listen failed: %s", listen_err), vim.log.levels.WARN)
		return
	end

	ide_context_server = server

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = vim.api.nvim_create_augroup("CodexIdeContext", { clear = true }),
		callback = function()
			for c in pairs(ide_context_clients) do
				close_client(c)
			end
			if ide_context_server then
				ide_context_server:close()
				ide_context_server = nil
			end
			pcall(vim.fn.delete, socket_path)
		end,
	})
end

-- ---------------------------------------------------------------------------
-- Codex launcher (spawns codex CLI in an external zellij pane with the right
-- TMPDIR so /ide finds our IPC socket).
-- ---------------------------------------------------------------------------

local function codex_running()
	return codex_job.id and codex_job.id > 0
end

local function launch_codex(extra_args)
	if codex_running() then
		vim.notify("Codex already running (use the existing zellij pane)", vim.log.levels.INFO)
		return
	end

	M.start_codex_ide_context_server()

	local tmpdir = M.codex_ide_context_tmpdir()
	local cmd = { "zellij", "run", "--cwd", vim.fn.getcwd(), "--", "env", "TMPDIR=" .. tmpdir, "codex" }
	if extra_args and extra_args ~= "" then
		for _, part in ipairs(vim.split(extra_args, " ", { trimempty = true })) do
			cmd[#cmd + 1] = part
		end
	end

	local jobid = vim.fn.jobstart(cmd, {
		detach = true,
		cwd = vim.fn.getcwd(),
		on_exit = function(jid)
			vim.schedule(function()
				if jid == codex_job.id then
					codex_job = {}
				end
			end)
		end,
	})

	if not jobid or jobid <= 0 then
		vim.notify("Failed to launch codex via zellij", vim.log.levels.ERROR)
		return
	end

	codex_job = { id = jobid, started_at = vim.uv.now() }
end

local function codex_unsupported(action)
	vim.notify(
		string.format("Codex: %s not wired — use /ide inside codex to pull current buffer/selection", action),
		vim.log.levels.INFO
	)
end

-- ---------------------------------------------------------------------------
-- Provider registry
-- ---------------------------------------------------------------------------

M.providers = {
	claude = {
		label = "Claude Code",
		plugin = "claudecode.nvim",
		actions = {
			toggle = function()
				vim.cmd("ClaudeCode")
			end,
			focus = function()
				vim.cmd("ClaudeCodeFocus")
			end,
			send = function()
				vim.cmd("ClaudeCodeSend")
			end,
			add_buffer = function()
				vim.cmd("ClaudeCodeAdd %")
			end,
			add_tree = function()
				vim.cmd("ClaudeCodeTreeAdd")
			end,
			diff_accept = function()
				vim.cmd("ClaudeCodeDiffAccept")
			end,
			diff_deny = function()
				vim.cmd("ClaudeCodeDiffDeny")
			end,
		},
	},
	codex = {
		label = "Codex",
		plugin = nil,
		actions = {
			toggle = function()
				launch_codex()
			end,
			focus = function()
				launch_codex()
			end,
			send = function()
				codex_unsupported("send selection")
			end,
			add_buffer = function()
				codex_unsupported("add buffer")
			end,
			add_tree = function()
				codex_unsupported("add tree")
			end,
			diff_accept = function()
				codex_unsupported("diff accept")
			end,
			diff_deny = function()
				codex_unsupported("diff deny")
			end,
		},
	},
}

-- ---------------------------------------------------------------------------
-- Provider state + dispatch
-- ---------------------------------------------------------------------------

local function normalize(provider)
	provider = string.lower(vim.trim(tostring(provider or "")))
	return M.providers[provider] and provider or nil
end

local function read_provider()
	local file = io.open(state_file, "r")
	if not file then
		return nil
	end
	local provider = file:read("*l")
	file:close()
	return normalize(provider)
end

local function write_provider(provider)
	vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
	local file = io.open(state_file, "w")
	if not file then
		return
	end
	file:write(provider .. "\n")
	file:close()
end

function M.initial_provider()
	return normalize(vim.env.NVIM_AI_PROVIDER) or read_provider() or default_provider
end

function M.current_provider()
	local provider = normalize(vim.g.ai_provider) or default_provider
	vim.g.ai_provider = provider
	return provider
end

function M.current()
	return M.providers[M.current_provider()]
end

local function load_plugin(provider)
	local plugin = M.providers[provider].plugin
	if not plugin then
		return
	end
	local ok, lazy = pcall(require, "lazy")
	if ok then
		pcall(lazy.load, { plugins = { plugin } })
	end
end

function M.toggle_provider()
	local next_provider = M.current_provider() == "claude" and "codex" or "claude"
	vim.g.ai_provider = next_provider
	write_provider(next_provider)
	load_plugin(next_provider)
	vim.notify("AI provider: " .. M.providers[next_provider].label, vim.log.levels.INFO)
end

function M.run(action)
	local provider = M.current_provider()
	local config = M.providers[provider]
	local handler = config.actions[action]

	if not handler then
		vim.notify(string.format("AI: action '%s' not available for %s", action, config.label), vim.log.levels.WARN)
		return
	end

	load_plugin(provider)
	local ok, err = pcall(handler)
	if not ok then
		vim.notify(string.format("%s: %s", config.label, err), vim.log.levels.ERROR)
	end
end

function M.add_context()
	local filetype = vim.bo.filetype
	if filetype == "neo-tree" or filetype == "oil" then
		M.run("add_tree")
	else
		M.run("add_buffer")
	end
end

function M.setup_keymaps()
	M.start_codex_ide_context_server()

	local ok, which_key = pcall(require, "which-key")
	if ok then
		which_key.add({ { "<leader>a", group = "AI" } })
	end

	vim.keymap.set("n", "<leader>at", M.toggle_provider, { desc = "Toggle AI provider" })
	vim.keymap.set("n", "<leader>ac", function()
		M.run("toggle")
	end, { desc = "Toggle AI" })
	vim.keymap.set("n", "<leader>af", function()
		M.run("focus")
	end, { desc = "Focus AI" })
	vim.keymap.set("v", "<leader>as", function()
		M.run("send")
	end, { desc = "Send to AI" })
	vim.keymap.set("n", "<leader>ab", M.add_context, { desc = "Add context to AI" })
	vim.keymap.set("n", "<leader>aa", function()
		M.run("diff_accept")
	end, { desc = "Accept AI diff" })
	vim.keymap.set("n", "<leader>ad", function()
		M.run("diff_deny")
	end, { desc = "Deny AI diff" })
end

return M
