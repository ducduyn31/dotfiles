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
}
