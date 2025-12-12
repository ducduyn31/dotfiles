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
			lsp = {
				color = {
					enabled = true,
				},
			},
			debugger = {
				enabled = true,
			},
			widget_guides = {
				enabled = true,
			},
		},
	},
}
