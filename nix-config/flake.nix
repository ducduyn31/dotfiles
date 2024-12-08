{
  description = "Daniel's nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-zsh-fzf-tab.url =
      "github:nixos/nixpkgs/8193e46376fdc6a13e8075ad263b4b5ca2592c03";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew
    , nixvim, ... }:
    let
      nixpkgsConfig = { allowUnfree = true; };
      globals = {
        user = "danielng";
        macHostname = "danielng-mbp";
      };
      system = "aarch64-darwin";

      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];
      # A helper to generate attrset { x86_64-linux = ...; aarch64-darwin = ...; ... }
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgs = import nixpkgs {
        config.allowUnfree = true;
        system = system;
      };

      nixvimModule = {
        inherit pkgs;
        module = import ./nixvim-config;
        extraSpecialArgs = { };
      };
      nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule nixvimModule;
      nvimLib = nixvim.lib.${system};

    in {
      checks = {
        default = nvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
      };

      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
      # Build darwin flake using:
      # $ darwin-rebuild switch --flake .#rose
      darwinConfigurations = {
        rose =
          import ./profiles/rose { inherit inputs globals nixpkgsConfig nvim; };
      };
    };
}
