{ ... }: {
  home.file.ghostty-config = {
    target = ".config/ghostty/config";
    text = ''
      font-family = JetBrains Mono
      background-opacity = 0.75
    '';
  };
}
