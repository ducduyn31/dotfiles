{ ... }: {
  homebrew = {
    enable = true;
    brews = [
      "mas"
      "sst/tap/sst" # sst

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
      "cursor"
      "ghostty"
      "orbstack"
      "visual-studio-code"
      # "wireshark"
      "dbeaver-community"
      "redis-insight"

      # productivity
      "raycast"
      "termius" # SSH Manager

      # streaming
      "obs"
      "cleanshot"
    ];
    masApps = { "Apple Configurator" = 1037126344; };
    taps = [
      # default
      "homebrew/bundle"
      "homebrew/services"
      # custom
      "nikitabobko/tap"
      "sst/tap"
    ];
    onActivation = {
      cleanup = "zap";
      upgrade = false;
      autoUpdate = false;
    };
  };
}
