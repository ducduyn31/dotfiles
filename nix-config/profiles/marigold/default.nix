{ pkgs, nvim, globals, lib, ... }: {
  imports = [ ../../shell ];
  home = {
    username = globals.user;
    homeDirectory =
      builtins.toPath (if pkgs.stdenv.isDarwin then "/Users" else "/home") + "/"
      + globals.user;
    stateVersion = "24.11";
    packages = [ nvim ];
  };
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
