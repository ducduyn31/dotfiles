{ pkgs, ... }: {
  imports = [
    ./homebrew.nix
  ];

  environment = {
    variables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    zsh.enable = true;
  };

  services = {
    nix-daemon.enable = true;
  };

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  security = {
    pam.enableSudoTouchIdAuth = true;
  };

  system.activationScripts.applications.text = let
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
  while read src; do
    app_name=$(basename "$src")
    echo "Copying $src" >&2
    ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  done
  '';

}
