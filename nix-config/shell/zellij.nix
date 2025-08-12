{lib, ...}: {
  programs.zellij = {enable = true;};

  home.file.zellij = {
    target = ".config/zellij/config.kdl";
    text = lib.strings.fileContents ./zellij.kdl;
  };
}
