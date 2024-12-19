{
  plugins.none-ls = {
    enable = true;
    enableLspFormat = true;
    settings = { updateInInsert = true; };
    sources = {
      code_actions = { };
      diagnostics = { mypy = { enable = true; }; };
      formatting = {
        nixfmt = { enable = true; };
        black = {
          enable = true;
          settings = ''
            {
              extra_args = { "--fast" },
            }
          '';
        };
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
        };
        stylua = { enable = true; };
        hclfmt = { enable = true; };
        isort = { enable = true; };
      };
    };
  };

  keymaps = [{
    mode = [ "n" "v" ];
    key = "<leader>cf";
    action = "<cmd>lua vim.lsp.buf.format()<CR>";
    options = {
      silent = true;
      desc = "[C]ode [F]ormat";
    };
  }];
}
