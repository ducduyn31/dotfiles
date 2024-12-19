{
  plugins.neotest = {
    enable = true;

    adapters = {
      golang = {
        enable = true;
        settings = { dap = { justMyCode = false; }; };
      };
      playwright = { enable = true; };
      python = {
        enable = true;
        settings = { dap = { justMyCode = false; }; };
      };
      jest = { enable = true; };
      vitest = { enable = true; };
    };

    settings = { };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>tt";
      action = ":lua require('neotest').run.run()<CR>";
      options = { desc = "[T]est [T]his function"; };
    }
    {
      mode = "n";
      key = "<leader>tT";
      action = ":lua require('neotest').run.run(vim.uv.cwd())<CR>";
      options = { desc = "[T]est All"; };
    }
    {
      mode = "n";
      key = "<leader>tl";
      action = ":lua require('neotest').run.run_last()<CR>";
      options = { desc = "[T]est [L]ast"; };
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = ":lua require('neotest').run.run(vim.fn.expand('%))<CR>";
      options = { desc = "[T]est [F]ile"; };
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = ":lua require('neotest').run.run_suite()<CR>";
      options = { desc = "[T]est [S]uite"; };
    }
    {
      mode = "n";
      key = "<leader>td";
      action = ":lua require('neotest').run.debug()<CR>";
      options = { desc = "[T]est [D]ebug"; };
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = ":lua require('neotest').summary.toggle()<CR>";
      options = { desc = "Toggle [T]est [S]ummary"; };
    }
    {
      mode = "n";
      key = "<leader>to";
      action = ":lua require('neotest').output_panel.toggle()<CR>";
      options = { desc = "Toggle [T]est [O]utput"; };
    }
    {
      mode = "n";
      key = "<leader>dm";
      action = ":lua require('neotest').run.run({ strategy = 'dap' })<CR>";
      options = { desc = "[D]ebug current [M]ethod"; };
    }
  ];
}
