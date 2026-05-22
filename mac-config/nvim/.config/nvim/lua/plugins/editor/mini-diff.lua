return {
	{
		"nvim-mini/mini.diff",
		keys = {
			{
				"<leader>ghr",
				function()
					require("mini.diff").do_hunks(0, "reset")
				end,
				desc = "Reset Hunk",
			},
			{
				"<leader>ghr",
				function()
					local s = vim.fn.line("v")
					local e = vim.fn.line(".")
					require("mini.diff").do_hunks(0, "reset", { line_start = math.min(s, e), line_end = math.max(s, e) })
				end,
				mode = "x",
				desc = "Reset Hunk",
			},
		},
	},
}
