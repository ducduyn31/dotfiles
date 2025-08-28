local function symbols_filter(entry, ctx)
	if ctx.symbols_filter == nil then
		ctx.symbols_filter = LazyVim.config.get_kind_filter(ctx.bufnr) or false
	end
	if ctx.symbols_filter == false then
		return true
	end
	return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

return {
	{
		"ibhagwan/fzf-lua",
		opts = {
			files = {
				fd_opts = "--color=never --type f --follow --exclude .git",
				actions = {
					["ctrl-h"] = require("fzf-lua.actions").toggle_hidden,
					["ctrl-i"] = require("fzf-lua.actions").toggle_ignore,
				},
			},
			grep = {
				actions = {
					["ctrl-h"] = require("fzf-lua.actions").toggle_hidden,
					["ctrl-i"] = require("fzf-lua.actions").toggle_ignore,
				},
			},
		},
		keymap = {
			fzf = {
				["ctrl-q"] = "select-all+accept",
			},
		},
		keys = {
			{ "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
			{ "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
			{
				"<leader>,",
				"<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{ "<leader>sg", LazyVim.pick("live_grep"), desc = "[S]earch [G]rep (Root Dir)" },
			{ "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
			{ "<leader><space>", LazyVim.pick("files"), desc = "[S]earch Files (Root Dir)" },
			{ "<leader>sb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "[S]earch [B]uffers" },
			{ "<leader>sc", LazyVim.pick.config_files(), desc = "[S]earch [C]onfig File" },
			{ "<leader>sf", LazyVim.pick("files"), desc = "[S]earch [F]iles (Root Dir)" },
			{ "<leader>sF", LazyVim.pick("files", { root = false }), desc = "[S]earch [F]iles (cwd)" },
			{ "<leader>sgf", "<cmd>FzfLua git_files<cr>", desc = "[S]earch [G]it [F]iles" },
			{ "<leader>so", "<cmd>FzfLua oldfiles<cr>", desc = "[S]earch [O]ld files" },
			{ "<leader>sR", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "[S]earch [R]ecent (cwd)" },
			-- git
			{ "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "List [G]it [C]ommits" },
			{ "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "List [G]it [S]tatus" },
			-- search
			{ '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
			{ "<leader>s/", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
			{ "<leader>s:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
			{ "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
			{ "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
			{ "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
			{ "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
			{ "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
			{ "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
			{ "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
			{ "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
			{ "<leader>sw", LazyVim.pick("grep_cword"), desc = "Word (Root Dir)" },
			{ "<leader>sW", LazyVim.pick("grep_cword", { root = false }), desc = "Word (cwd)" },
			{ "<leader>sw", LazyVim.pick("grep_visual"), mode = "v", desc = "Selection (Root Dir)" },
			{ "<leader>sW", LazyVim.pick("grep_visual", { root = false }), mode = "v", desc = "Selection (cwd)" },
			{ "<leader>uC", LazyVim.pick("colorschemes"), desc = "Colorscheme with Preview" },
			{
				"<leader>ss",
				function()
					require("fzf-lua").lsp_document_symbols({
						regex_filter = symbols_filter,
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				function()
					require("fzf-lua").lsp_live_workspace_symbols({
						regex_filter = symbols_filter,
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
	},
}
