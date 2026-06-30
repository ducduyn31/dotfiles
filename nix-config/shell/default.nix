{pkgs, ...}: {
  imports = [./zsh.nix ./bash.nix ./tmux.nix ./zellij.nix];

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
      lazydocker
      gh
      coreutils
      go-task
      rsync

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
      # flyctl # Fly.io CLI
      # gnuplot # Tools for other software to plots
      dwt1-shell-color-scripts # Collection of shell color scripts
      # qsv # CSV manipulation command line tools
      # visidata # CSV viewer
      circleci-cli
      # gitleaks
      # git-filter-repo
      # renovate
    ];

    shellAliases = {
      # builtins
      ll = "ls -l";
      la = "ls -la";
      mkdir = "mkdir -p";
      gdate = "date";
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

    mise = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd zx"];
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
    };

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
