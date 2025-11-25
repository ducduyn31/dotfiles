{pkgs, ...}: {
  programs.git = {
    enable = true;

    lfs = {enable = true;};

    settings = {
      merge = {tool = "nvim";};
      mergetool = {
        nvim = {cmd = ''nvim -f -c "Gvdiffsplit!" "$MERGED"'';};
        prompt = false;
      };
      delta = {navigate = true;};
    };

    includes = [{path = "~/.gitconfig";}];
  };

  programs.delta = {
    enable = true;
    package = pkgs.delta;
    enableGitIntegration = true;
  };
}
