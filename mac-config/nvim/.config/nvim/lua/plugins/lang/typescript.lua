return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				vtsls = { enabled = false },
				tsserver = { enabled = false },
			},
		},
	},
}
