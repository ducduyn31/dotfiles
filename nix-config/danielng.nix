{ pkgs, ... }: {
  home.username = "danielng";
  home.homeDirectory = "/Users/danielng";

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.packages = [
  ];

  programs.starship = {
    enable = true;
  };
}
