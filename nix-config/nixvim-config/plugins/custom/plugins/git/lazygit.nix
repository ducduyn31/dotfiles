{
  plugins.lazygit = {
    enable = true;
  };

  extraConfigLua = ''
    require('telescope').load_extension('lazygit')
  '';

  keymaps = [
    {
      key = "<leader>gg";
      action = "<cmd>LazyGit<CR>";
      options = {
        desc = "LazyGit open";
      };
    }
  ];
}
