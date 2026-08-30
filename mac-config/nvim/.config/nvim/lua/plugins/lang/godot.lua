return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "gdscript", "godot_resource", "gdshader" } },
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- The LSP is the running Godot editor itself (127.0.0.1:6005),
				-- so there is nothing for mason to install.
				gdscript = { mason = false },
			},
		},
		init = function()
			-- Godot's "external editor" talks to this pipe. Only start it in a
			-- Godot project so every other nvim session stays unaffected.
			if vim.uv.fs_stat("project.godot") then
				pcall(vim.fn.serverstart, "./godothost")
			end
		end,
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
		opts = function()
			local dap = require("dap")
			-- Godot 4 ships a DAP server: Editor Settings > Network > Debug Adapter.
			dap.adapters.godot = { type = "server", host = "127.0.0.1", port = 6006 }
			dap.configurations.gdscript = {
				{
					type = "godot",
					request = "launch",
					name = "Launch scene",
					project = "${workspaceFolder}",
				},
			}
		end,
	},
}
