-- Codex is intentionally NOT configured via a Neovim plugin. The codex.nvim
-- plugin speaks claudecode's WebSocket+lockfile protocol, but OpenAI's actual
-- `codex` CLI uses a Unix-domain-socket IPC ($TMPDIR/codex-ipc/ipc-{uid}.sock).
-- That IPC server is implemented in config/ai.lua, and codex is launched via
-- `zellij run` with TMPDIR forwarded so /ide can discover it.

return {
	{
		"coder/claudecode.nvim",
		lazy = true,
		cmd = {
			"ClaudeCode",
			"ClaudeCodeFocus",
			"ClaudeCodeOpen",
			"ClaudeCodeClose",
			"ClaudeCodeSend",
			"ClaudeCodeAdd",
			"ClaudeCodeTreeAdd",
			"ClaudeCodeDiffAccept",
			"ClaudeCodeDiffDeny",
		},
		dependencies = { "folke/snacks.nvim" },
		opts = {
			port_range = { min = 10000, max = 65535 },
			auto_start = true,
			log_level = "info",
			terminal = {
				provider = "external",
				provider_opts = {
					external_terminal_cmd = "zellij run -- %s",
				},
			},
		},
		config = true,
	},
}
