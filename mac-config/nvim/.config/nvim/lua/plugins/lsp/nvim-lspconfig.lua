return {
	{
		"neovim/nvim-lspconfig",
		config = function(_, opts)
			local lspconfig = require("lspconfig")

			-- Only proceed if we have servers to configure
			if type(opts.servers) ~= "table" then
				return
			end

			-- Setup handlers for custom servers
			opts.setup = opts.setup or {}

			for server, config in pairs(opts.servers) do
				-- Skip the wildcard server (used by LazyVim for default config)
				if server == "*" then
					-- Skip - this is handled by LazyVim's lsp config
				-- Skip disabled servers
				elseif config.enabled == false then
					-- Skip silently
					-- Skip servers that have a custom setup handler
				elseif opts.setup[server] and opts.setup[server](server, config) then
					-- Custom setup handled
					-- Check if the server exists in lspconfig
				elseif lspconfig[server] then
					-- Safely get capabilities
					local has_blink_cmp, blink_cmp = pcall(require, "blink.cmp")
					if has_blink_cmp and type(blink_cmp.get_lsp_capabilities) == "function" then
						config.capabilities = blink_cmp.get_lsp_capabilities(config.capabilities)
					end
					lspconfig[server].setup(config)
				else
					-- Server not found, skip silently
				end
			end
		end,
		dependencies = {
			"saghen/blink.cmp",
		},
	},
}

