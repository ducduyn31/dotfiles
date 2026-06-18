-- Pick OpenTofu (tofu) vs Terraform per-project for linting/formatting.
--
-- The LazyVim terraform extra wires up `terraform_validate` (nvim-lint) and
-- `terraform_fmt` (conform), both hardcoded to the `terraform` binary. Since
-- .tf files and .terraform.lock.hcl are shared by both tools, we detect tofu
-- via tofu-specific markers and fall back to terraform otherwise.

-- True if `path` lives in a project that should use tofu.
local function is_tofu_project(path)
	if not path or path == "" then
		return false
	end
	-- explicit version pins (tofuenv / asdf opentofu)
	if vim.fs.root(path, { ".opentofu-version", ".tofu-version" }) then
		return true
	end
	-- OpenTofu-only `.tofu` file extension somewhere in the config root
	local root = vim.fs.root(path, { ".terraform.lock.hcl", ".git" }) or vim.fs.dirname(path)
	if root and vim.fn.glob(root .. "/*.tofu") ~= "" then
		return true
	end
	return false
end

-- Resolve which binary to run for `path`.
local function tf_bin(path)
	if is_tofu_project(path) then
		return "tofu"
	end
	if vim.fn.executable("terraform") == 1 then
		return "terraform"
	end
	return "tofu" -- last resort if only tofu is installed
end

return {
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = function(_, opts)
			local lint = require("lint")
			-- nvim-lint re-evaluates the linter (and its `cmd`) on every run, so the
			-- binary is chosen fresh against the current buffer's project.
			lint.linters.tf_validate = function()
				local spec = lint.linters.tofu() -- tofu/terraform emit identical validate JSON
				spec.cmd = tf_bin(vim.api.nvim_buf_get_name(0))
				return spec
			end

			opts.linters_by_ft = opts.linters_by_ft or {}
			opts.linters_by_ft.terraform = { "tf_validate" }
			opts.linters_by_ft.tf = { "tf_validate" }
		end,
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters = {
				terraform_fmt = {
					command = function(_, ctx)
						return tf_bin(ctx.filename)
					end,
				},
			},
		},
	},
}
