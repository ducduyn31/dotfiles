{ pkgs, pkgs-zsh-fzf-tab, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = false;
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

    initExtra = ''
      autoload -U compinit
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zsh_cache
      compinit -d ~/.zcompdump

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

      # Set up fnm
      if command -v fnm &> /dev/null; then
        eval "$(fnm env --use-on-cd --shell zsh)"
      fi

      # Import user zsh configuration
      [ -f ~/.zshrc.local ] && source ~/.zshrc.local
    '';

    shellAliases = {
      z = "zellij";
      za =
        "zellij attach $(zellij list-sessions | fzf --ansi | awk '{print $1}')";
      zd =
        "zellij delete-session $(zellij list-sessions | fzf --ansi | awk '{print $1}') --force";
      zk =
        "zellij kill-session $(zellij list-sessions | fzf --ansi | awk '{print $1}')";
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

    prezto = {
      enable = true;
      caseSensitive = false;
      utility.safeOps = true;
      tmux.autoStartLocal = true;
      editor = {
        dotExpansion = true;
        keymap = "vi";
      };
      pmodules = [ "autosuggestions" "directory" "editor" "git" "terminal" ];
    };
  };
}
