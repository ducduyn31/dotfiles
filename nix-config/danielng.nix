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

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -g mouse on
    '';
  };
}
