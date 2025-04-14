{ pkgs, ... }: {
  imports = [ ./zsh.nix ./tmux.nix ./zellij.nix ];

  home = {
    packages = [
      # Must have
      pkgs.vim
      pkgs.neovim
      pkgs.tmux
      pkgs.starship
      pkgs.bat
      pkgs.ripgrep
      pkgs.fd
      pkgs.jq
      pkgs.jqp
      pkgs.fzf # Fuzzy finder
      pkgs.inetutils
      pkgs.lazygit
      pkgs.gh
      pkgs.coreutils

      # Utils for cli
      pkgs.tree # Directory listing
      pkgs.zenith # System monitoring
      pkgs.nmap # Network scanner
      pkgs.openssl # SSL/TLS toolkit
      pkgs.wget # HTTP client
      pkgs.curl # HTTP client
      pkgs.httpie # HTTP client
      pkgs.unixtools.watch
      pkgs.tmate # Terminal sharing
      pkgs.tealdeer # Better man pages
      pkgs.stow # Symlink Manager
      pkgs.flyctl # Fly.io CLI
      pkgs.gnuplot # Tools for other software to plots
      pkgs.dwt1-shell-color-scripts # Collection of shell color scripts
    ];

    shellAliases = {
      # builtins
      ll = "ls -l";
      la = "ls -la";
      mkdir = "mkdir -p";
    };

    sessionPath = [ "$HOME/go/bin" "$HOME/.local/bin" "$HOME/.cargo/bin" ];

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
      defaultCommand =
        "fd --type f --follow --exclude .git --exclude node_modules --exclude .vim --exclude .cache --exclude vendor";
      defaultOptions = [ "--border sharp" "--inline-info" ];
    };

    gh = {
      enable = true;
      extensions = [ pkgs.gh-notify ];
    };

    starship = { enable = true; };
  };
}
