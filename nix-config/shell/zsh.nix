{
  pkgs,
  pkgs-zsh-fzf-tab,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;

    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 20000;
      size = 20000;
      share = true;
    };

    initContent = ''
      # Fix insecure directories
      if [[ -d /nix/var/nix/profiles/default/share/zsh ]]; then
        chmod -R go-w /nix/var/nix/profiles/default/share/zsh &> /dev/null
      fi

      # Load environment variables
      [ -f ~/.env/env.sh ] && source ~/.env/env.sh

      # used for homebrew
      export XDG_DATA_DIRS=$XDG_DATA_DIRS:/opt/homebrew/share

      bindkey '^w' edit-command-line
      bindkey '^ ' autosuggest-accept
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^f' fzf-file-widget

      # Set up volta
      if command -v volta &> /dev/null; then
        export VOLTA_HOME="$HOME/.volta"
        export PATH="$VOLTA_HOME/bin:$PATH"
      fi

      # Import user zsh configuration
      [ -f ~/.zshrc.local ] && source ~/.zshrc.local

      # Set up terraform autocomplete
      if command -v terraform &> /dev/null; then
        complete -C "$(which terraform)" terraform
      fi

      # Set up aws completion
      if command -v aws_completer &> /dev/null; then
        complete -C '$(which aws_completer)' aws
      fi

      # Set up orbstack completion
      if command -v docker &> /dev/null; then
        eval "$(docker completion zsh)"
      fi
    '';

    shellAliases = {
      z = "zellij";
      za = "zellij attach $(zellij list-sessions | fzf --ansi | awk '{print $1}')";
      zd = "zellij delete-session $(zellij list-sessions | fzf --ansi | awk '{print $1}') --force";
      zk = "zellij kill-session $(zellij list-sessions | fzf --ansi | awk '{print $1}')";
      date = "coreutils --coreutils-prog=date";
    };

    plugins = [
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "zsh-nix-shell";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        name = "forgit";
        src = "${pkgs.zsh-forgit}/share/zsh/zsh-forgit";
      }
      {
        name = "fzf-tab";
        src = "${pkgs-zsh-fzf-tab.zsh-fzf-tab}/share/fzf-tab";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "brew"
        "vi-mode"
        "docker"
        "kubectl"
        "aws"
        "terraform"
      ];
    };
  };
}
