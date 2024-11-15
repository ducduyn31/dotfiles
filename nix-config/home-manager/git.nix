{ pkgs, ... }: {
  programs.git = {
    enable = true;

    lfs = {
      enable = true;
    };

    delta = {
      enable = true;
      options = {
      };
    };

    includes = [
      { path = "~/.gitconfig" }
    ];
  }
}
