{ pkgs, ... }: {
  imports = [
    # Plugins

    # Git
    ./plugins/custom/plugins/git/lazygit.nix # Easy git interface
    ./plugins/custom/plugins/git/gitsigns.nix # Show git changes in the gutter
    ./plugins/custom/plugins/git/fugitive.nix # For handling git conflicts

    # LSP
    ./plugins/conform.nix # Various LSP configurations for formatting, linting, etc.
    ./plugins/lsp.nix # Base LSP configuration
    ./plugins/treesitter.nix # Treesitter for syntax highlighting
    ./plugins/custom/plugins/lsp/typescript.nix # TypeScript LSP
    ./plugins/custom/plugins/lsp/none-ls.nix # LSP for formatting and linting
    ./plugins/custom/plugins/lsp/trouble.nix # Show LSP errors in a list
    ./plugins/kickstart/plugins/lint.nix # Linting
    ./plugins/kickstart/plugins/autopairs.nix # Auto pairs
    ./plugins/kickstart/plugins/debug.nix # Debugging

    # UI
    ./plugins/telescope.nix # Fuzzy finder
    ./plugins/kickstart/plugins/indent-blankline.nix # Indentation lines
    ./plugins/custom/plugins/ui/precognition.nix # Show location of the next character you type
    ./plugins/custom/plugins/ui/bufferline.nix # Show bufferline

    # Utilities
    ./plugins/which-key.nix # Show keybindings
    ./plugins/mini.nix # Various utilities
    ./plugins/custom/plugins/utils/markview.nix
    ./plugins/kickstart/plugins/neo-tree.nix # File tree explorer
    # ./plugins/custom/plugins/utils/ufo.nix # Foldings and more

    # Completion
    ./plugins/nvim-cmp.nix # Completion
    ./plugins/copilot-vim.nix # Copilot completion
    ./plugins/copilot-chat.nix # Copilot chat
  ];

  # You can easily change to a different colorscheme.
  # Add your colorscheme here and enable it.
  # Don't forget to disable the colorschemes you arent using
  #
  # If you want to see what colorschemes are already installed, you can use `:Telescope colorschme`.
  colorschemes = {
    rose-pine = {
      enable = true;
      settings = { transparency = true; };
    };
  };

  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#globals
  globals = {
    # Set <space> as the leader key
    # See `:help mapleader`
    mapleader = " ";
    maplocalleader = " ";

    # Set to true if you have a Nerd Font installed and selected in the terminal
    have_nerd_font = true;
  };

  clipboard = {
    providers = {
      wl-copy.enable = true; # For Wayland
      xsel.enable = true; # For X11
    };
    # Sync clipboard between OS and Neovim
    #  Remove this option if you want your OS clipboard to remain independent.
    #  See `:help 'clipboard'`
    register = "unnamedplus";
  };

  # [[ Setting options ]]
  # See `:help vim.opt`
  # NOTE: You can change these options as you wish!
  #  For more options, you can see `:help option-list`
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#opts
  opts = {
    # Show line numbers
    number = true;
    # You can also add relative line numbers, to help with jumping.
    #  Experiment for yourself to see if you like it!
    relativenumber = true;

    # Enable mouse mode, can be useful for resizing splits for example!
    mouse = "a";

    # Don't show the mode, since it's already in the statusline
    showmode = false;

    # Enable break indent
    breakindent = true;

    # Save undo history
    undofile = true;

    # Case-insensitive searching UNLESS \C or one or more capital letters in search term
    ignorecase = true;
    smartcase = true;

    # Keep signcolumn on by default
    signcolumn = "yes";

    # Decrease update time
    updatetime = 250;

    # Decrease mapped sequence wait time
    # Displays which-key popup sooner
    timeoutlen = 300;

    # Configure how new splits should be opened
    splitright = true;
    splitbelow = true;

    # Sets how neovim will display certain whitespace characters in the editor
    #  See `:help 'list'`
    #  See `:help 'listchars'`
    list = true;
    # NOTE: .__raw here means that this field is raw lua code
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

    # Preview subsitutions live, as you type!
    inccommand = "split";

    # Show which line your cursor is on
    cursorline = true;

    # Minimal number of screen lines to keep above and below the cursor
    scrolloff = 10;

    # Set highlight on search, but clear on pressing <Esc> in normal mode
    hlsearch = true;

    # Redefine tab settings
    expandtab = true;
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;

    # Set color column to 80 characters
    colorcolumn = "80";
  };

  # [[ Basic Keymaps ]]
  #  See `:help vim.keymap.set()`
  # https://nix-community.github.io/nixvim/keymaps/index.html
  keymaps = [
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }
    # Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
    # for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
    # is not what someone will guess without a bit more experience.
    #
    # NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
    # or just use <C-\><C-n> to exit terminal mode
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options = { desc = "Exit terminal mode"; };
    }
    # TIP: Disable arrow keys in normal mode
    /* {
         mode = "n";
         key = "<left>";
         action = "<cmd>echo 'Use h to move!!'<CR>";
       }
       {
         mode = "n";
         key = "<right>";
         action = "<cmd>echo 'Use l to move!!'<CR>";
       }
       {
         mode = "n";
         key = "<up>";
         action = "<cmd>echo 'Use k to move!!'<CR>";
       }
       {
         mode = "n";
         key = "<down>";
         action = "<cmd>echo 'Use j to move!!'<CR>";
       }
    */
    # Keybinds to make split navigation easier.
    #  Use CTRL+<hjkl> to switch between windows
    #
    #  See `:help wincmd` for a list of all window commands
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options = { desc = "Move focus to the left window"; };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options = { desc = "Move focus to the right window"; };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options = { desc = "Move focus to the lower window"; };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options = { desc = "Move focus to the upper window"; };
    }
  ];

  # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
  autoGroups = { kickstart-highlight-yank = { clear = true; }; };

  # [[ Basic Autocommands ]]
  #  See `:help lua-guide-autocommands`
  # https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html
  autoCmd = [
    # Highlight when yanking (copying) text
    #  Try it with `yap` in normal mode
    #  See `:help vim.highlight.on_yank()`
    {
      event = [ "TextYankPost" ];
      desc = "Highlight when yanking (copying) text";
      group = "kickstart-highlight-yank";
      callback.__raw = ''
        function()
          vim.highlight.on_yank()
        end
      '';
    }
  ];

  plugins = {
    # Adds icons for plugins to utilize in ui
    web-devicons.enable = true;

    # Detect tabstop and shiftwidth automatically
    # https://nix-community.github.io/nixvim/plugins/sleuth/index.html
    sleuth = { enable = true; };

    # "gc" to comment visual regions/lines
    # https://nix-community.github.io/nixvim/plugins/comment/index.html
    comment = { enable = true; };

    # Highlight todo, notes, etc in comments
    # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
    todo-comments = {
      enable = true;
      settings.signs = true;
    };
  };

  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraplugins
  extraPlugins = with pkgs.vimPlugins;
    [
      # Useful for getting pretty icons, but requires a Nerd Font.
      nvim-web-devicons # TODO: Figure out how to configure using this with telescope
    ];

  # TODO: Figure out where to move this
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapre
  extraConfigLuaPre = ''
    if vim.g.have_nerd_font then
      require('nvim-web-devicons').setup {}
    end
  '';

  # The line beneath this is called `modeline`. See `:help modeline`
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
  extraConfigLuaPost = ''
    -- vim: ts=2 sts=2 sw=2 et

    -- Check if dap-python is installed
    local has_dap_python, dap_python = pcall(require, 'dap-python')
    if has_dap_python then
      -- Set keymap to go to test method
      vim.api.nvim_set_keymap('n', '<leader>dm', '<cmd>lua require("dap-python").test_method({ config = { justMyCode = false } })<CR>', { noremap = true, silent = true, desc = 'Go to test method' })
    end
  '';
}
