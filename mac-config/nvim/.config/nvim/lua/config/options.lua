-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_picker = "fzf"
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.snacks_animate = false

-- Shared <leader>a AI keymaps. Toggle in-session with <leader>at.
-- Override the persisted provider with NVIM_AI_PROVIDER=codex nvim.
vim.g.ai_provider = require("config.ai").initial_provider()

-- Rust
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- Python
vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_python_lsp = "basedpyright"
