{ config, pkgs, lib, ... }: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = lib.strings.fileContents ./tmux.conf;
  };
}
