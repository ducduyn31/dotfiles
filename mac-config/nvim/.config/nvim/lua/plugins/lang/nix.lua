return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Use nixd (installed via nix); disable LazyVim's default nil_ls so
        -- mason doesn't try to cargo-build it.
        nil_ls = { enabled = false },
        nixd = {},
      },
    },
  },
}