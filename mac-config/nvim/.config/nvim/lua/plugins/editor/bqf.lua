return {
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        auto_preview = false,
      },
    },
    config = function(_, opts)
      require("bqf").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
          vim.keymap.set("n", "dd", function()
            local list = vim.fn.getqflist()
            local idx = vim.fn.line(".")
            table.remove(list, idx)
            vim.fn.setqflist(list, "r")
            vim.cmd("normal! " .. math.min(idx, #list) .. "G")
          end, { buffer = true, desc = "Remove entry from quickfix" })
          vim.keymap.set("v", "d", function()
            local start_idx = vim.fn.line("v")
            local end_idx = vim.fn.line(".")
            if start_idx > end_idx then
              start_idx, end_idx = end_idx, start_idx
            end
            local list = vim.fn.getqflist()
            for i = end_idx, start_idx, -1 do
              table.remove(list, i)
            end
            vim.fn.setqflist(list, "r")
            vim.cmd("normal! " .. math.min(start_idx, #list) .. "G")
          end, { buffer = true, desc = "Remove entries from quickfix" })
        end,
      })
    end,
  },
}
