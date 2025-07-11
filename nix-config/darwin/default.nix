{ pkgs, config, ... }: {
  imports = [ ./homebrew.nix ];

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs = { zsh.enable = true; };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  security = { pam.services.sudo_local.touchIdAuth = true; };

  system = {
    primaryUser = "danielng";
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        orientation = "bottom";
        dashboard-in-overlay = true;
        largesize = 85;
        tilesize = 50;
        magnification = true;
        launchanim = false;
        # mru-spaces = false;
        show-recents = false;
        show-process-indicators = true;
        static-only = false;
      };

      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        QuitMenuItem = true;
      };

      NSGlobalDomain = { ApplePressAndHoldEnabled = false; };
    };
    activationScripts.applications.text = let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in ''
      # Set up applications.
      echo "Setting up applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "Copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';
  };
}
