-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
require("config.ai").setup_keymaps()

-- ponytail: reuses Snacks' git_log format/preview/confirm handlers, only the finder is custom (line-range -L)
vim.keymap.set("x", "<leader>gb", function()
	local s, e = vim.fn.line("v"), vim.fn.line(".")
	if s > e then
		s, e = e, s
	end
	local file = vim.fn.expand("%:p")
	local cwd = Snacks.git.get_root(vim.fn.fnamemodify(file, ":h")) or vim.fn.fnamemodify(file, ":h")

	Snacks.picker.pick({
		source = "git_log_range",
		title = ("Git Log (lines %d-%d)"):format(s, e),
		finder = function(opts, ctx)
			return require("snacks.picker.source.proc").proc(
				ctx:opts({
					cmd = "git",
					cwd = cwd,
					args = {
						"-c",
						"core.quotepath=false",
						"log",
						"--pretty=format:%h %s (%ch) <%an>",
						"--abbrev-commit",
						"--decorate",
						"--date=short",
						"--color=never",
						"--no-show-signature",
						"-L",
						s .. "," .. e .. ":" .. file,
					},
					transform = function(item)
						local commit, msg, date, author = item.text:match("^(%S+) (.*) %((.*)%) <(.*)>$")
						if not commit then
							return false
						end
						item.cwd = cwd
						item.commit = commit
						item.msg = msg
						item.date = date
						item.author = author
						item.file = file
					end,
				}),
				ctx
			)
		end,
		format = "git_log",
		preview = "git_show",
		confirm = "git_checkout",
	})
end, { desc = "Git Log for Selection" })
