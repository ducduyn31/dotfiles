{ ... }: {
  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "hammerspoon"
      "the-unarchiver"
    ];
    masApps = {
    };
    onActivation = {
      cleanup = "zap";
      upgrade = false;
      autoUpdate = false;
    };
  };
}
