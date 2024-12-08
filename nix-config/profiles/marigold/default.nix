{ inputs, globals, ... }:

with inputs;
home-manager.lib.homeManagerConfiguration {
  home = globals.user;
  extraSpecialArgs = { };
  modules = [ ];
}
