{
  description = "Daniel's configuration";

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
      globals = {
        user = "danielng";
        macHostname = "danielng-mbp";
      };

      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];
      # A helper to generate attrset { x86_64-linux = ...; aarch64-darwin = ...; ... }
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsConfig = { allowUnfree = true; };
      pkgsForSystem = system:
        import nixpkgs {
          config = nixpkgsConfig;
          inherit system;
        };

      nixvimModule = system: {
        pkgs = pkgsForSystem system;
        module = import ./nixvim-config;
        extraSpecialArgs = { };
      };
      nvim = system:
        nixvim.legacyPackages.${system}.makeNixvimWithModule
        (nixvimModule system);
      nvimLib = system: nixvim.lib.${system};
    in {
      checks = forAllSystems (system:
        nvimLib.check.mkTestDerivationFromNixvimModule (nixvimModule system));
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      # Build linux flake using:
      # $ home-manager switch --flake .#marigold
      homeConfigurations = {
        marigold = import ./profiles/marigold { inherit inputs globals; };
      };

      # Build darwin flake using:
      # $ darwin-rebuild switch --flake .#rose
      darwinConfigurations = {
        rose = import ./profiles/rose {
          inherit inputs globals nixpkgsConfig;
          nvim = nvim "aarch64-darwin";
        };
      };
    };
}
