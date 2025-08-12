{pkgs, ...}: {
  programs.git = {
    enable = true;

    lfs = {enable = true;};

    delta = {
      enable = true;
      package = pkgs.delta;
    };

    extraConfig = {
      merge = {tool = "nvim";};
      mergetool = {
        nvim = {cmd = ''nvim -f -c "Gvdiffsplit!" "$MERGED"'';};
        prompt = false;
      };
      delta = {navigate = true;};
    };

    includes = [{path = "~/.gitconfig";}];
  };
}
