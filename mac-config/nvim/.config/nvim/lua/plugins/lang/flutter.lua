return {
	-- Treesitter for Dart
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "dart" } },
	},
	-- Flutter tools (LSP, commands, hot reload, etc.)
	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		opts = {
			debugger = {
				enabled = true,
			},
			widget_guides = {
				enabled = true,
			},
		},
		config = function(_, opts)
			require("flutter-tools").setup(opts)
			-- flutter-tools' plugin-managed lsp.color is deprecated on Neovim 0.12+.
			-- Use the native document color API instead.
			if vim.lsp.document_color then
				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(args)
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						if client and client.name == "dartls" then
							vim.lsp.document_color.enable(true, args.buf)
						end
					end,
				})
			end
		end,
	},
}
