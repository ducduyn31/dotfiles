{ pkgs, ... }: {
  home.username = "danielng";

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.packages = [
  ];

  programs.zsh.enable = true;

  programs.starship = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 16;
      };
      window = {
        opacity = 0.75;
        padding = {
          x = 5;
          y = 10;
        };
        decorations = "Transparent";
        startup_mode = "SimpleFullscreen";
      };
      colors = {
        transparent_background_colors = true;
      };
      selection.save_to_clipboard = true;
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -g mouse on
    '';
  };
}
