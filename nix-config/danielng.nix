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
