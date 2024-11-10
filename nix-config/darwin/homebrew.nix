{ ... }: {
  homebrew = {
    enable = true;
    brews = [
      "mas"

      # dependencies
      "pkg-config"
      "cairo"
      "pango"
      "libpng"
      "jpeg"
      "giflib"
      "librsvg"
    ];
    casks = [
      "hammerspoon"
      "the-unarchiver"
      "nikitabobko/tap/aerospace" # tiling window manager
      "arc"
      "spotify"

      # communication
      "microsoft-teams"
      # "zoom"
      "discord"

      # development
      "postman"
      "zed"
      # "wireshark"

      # productivity
      "raycast"
    ];
    masApps = {
    };
    taps = [
      # default
      "homebrew/bundle"
      "homebrew/services"
      # custom
      "nikitabobko/tap"
    ];
    onActivation = {
      cleanup = "zap";
      upgrade = false;
      autoUpdate = false;
    };
  };
}
