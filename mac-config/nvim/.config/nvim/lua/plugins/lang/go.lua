return {
	{
		"ray-x/go.nvim",
		enabled = false,
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = '":lua require("go.install").update_all_sync()',
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			setup = {
				-- ponytail: LazyVim's upstream workaround indexes
				-- client.config.capabilities.textDocument without a nil check;
				-- guard it here instead of patching the vendored plugin file.
				gopls = function(_, _opts)
					Snacks.util.lsp.on({ name = "gopls" }, function(_, client)
						if client.server_capabilities.semanticTokensProvider then
							return
						end
						local semantic = client.config.capabilities.textDocument and client.config.capabilities.textDocument.semanticTokens
						if not semantic then
							return
						end
						client.server_capabilities.semanticTokensProvider = {
							full = true,
							legend = {
								tokenTypes = semantic.tokenTypes,
								tokenModifiers = semantic.tokenModifiers,
							},
							range = true,
						}
					end)
				end,
			},
		},
	},
}
