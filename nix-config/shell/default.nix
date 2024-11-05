{ pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./tmux.nix
  ];

  home = {
    packages = [
      # Must have
      pkgs.vim
      nvim # Custom
      pkgs.tmux
      pkgs.starship
      pkgs.bat
      pkgs.ripgrep
      pkgs.fd
      pkgs.jq
      pkgs.fzf
      pkgs.inetutils

      # Utils for cli
      pkgs.alacritty
      pkgs.tree
      pkgs.zenith
      pkgs.nmap
      pkgs.openssl
      pkgs.wget
      pkgs.curl
      pkgs.httpie
      pkgs.unixtools.watch
      pkgs.tmate
      pkgs.nnn

      # Java/Kotlin tools
      pkgs.gradle
      pkgs.kotlin
      pkgs.ktlint

      # Javascript
      pkgs.pnpm
      pkgs.fnm
      pkgs.bun
      pkgs.supabase-cli

      # Python
      pkgs.python3
      pkgs.poetry

      # Golang
      pkgs.cue
      pkgs.golangci-lint

      # Infrastructure
      pkgs.terraform
      pkgs.terragrunt
      pkgs.kubectl
      pkgs.kubernetes-cli

      # GUI apps
      pkgs.mkalias
      pkgs.obsidian
      pkgs.appcleaner
    ];

    shellAliases = {
      # builtins
      ll = "ls -l";
      la = "ls -la";
      mkdir = "mkdir -p";
    };

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];

    sessionVariables = {
      GO111MODULE = "on";
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  programs = {
    home-manager.enable = true;

    jq.enable = true;
    bat.enable = true;
    nnn.enable = true;
    zenith.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --follow --exclude .git --exclude node_modules --exclude .vim --exclude .cache --exclude vendor";
      defaultOptions = [
        "--border sharp"
        "--inline-info"
      ];
    };

    starship = {
      enable = true;
    };

    go = {
      enable = true;
      packages = pkgs.go_1_22;
      goPath = "go";
      goBin = "go/bin";
      goPrivate = [ ];
    };
  };
}
