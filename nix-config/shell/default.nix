{pkgs, ...}: {
  imports = [./zsh.nix ./tmux.nix ./zellij.nix];

  home = {
    packages = with pkgs; [
      # Must have
      vim
      neovim
      tmux
      starship
      bat
      ripgrep
      fd
      jq
      yq-go
      jqp
      fzf # Fuzzy finder
      inetutils
      lazygit
      gh
      coreutils

      # Utils for cli
      tree # Directory listing
      zenith # System monitoring
      nmap # Network scanner
      openssl # SSL/TLS toolkit
      wget # HTTP client
      curl # HTTP client
      httpie # HTTP client
      unixtools.watch
      tmate # Terminal sharing
      tealdeer # Better man pages
      stow # Symlink Manager
      flyctl # Fly.io CLI
      gnuplot # Tools for other software to plots
      dwt1-shell-color-scripts # Collection of shell color scripts
      qsv # CSV manipulation command line tools
      visidata # CSV viewer
      circleci-cli
      gitleaks
      git-filter-repo
    ];

    shellAliases = {
      # builtins
      ll = "ls -l";
      la = "ls -la";
      mkdir = "mkdir -p";
    };

    sessionPath = ["$HOME/go/bin" "$HOME/.local/bin" "$HOME/.cargo/bin"];

    sessionVariables = {
      GO111MODULE = "on";
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
      VISUAL = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  programs = {
    home-manager.enable = true;

    jq.enable = true;
    bat.enable = true;
    nnn.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --follow --exclude .git --exclude node_modules --exclude .vim --exclude .cache --exclude vendor";
      defaultOptions = ["--border sharp" "--inline-info"];
    };

    gh = {
      enable = true;
      extensions = [pkgs.gh-notify];
    };

    starship = {enable = true;};
  };
}
