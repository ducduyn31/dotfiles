return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "groovy" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- groovy-language-server is auto-installed by mason-lspconfig.
        -- It's a JDK-based server, so a `java` binary must be on PATH.
        groovyls = {},
      },
    },
  },
}
