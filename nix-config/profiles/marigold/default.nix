{
  pkgs,
  globals,
  lib,
  ...
}: {
  imports = [../../shell];
  home = {
    username = globals.user;
    homeDirectory =
      builtins.toPath (
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/Users"
        else "/home"
      )
      + "/"
      + globals.user;
    stateVersion = "25.05";
  };
  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
