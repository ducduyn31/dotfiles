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

    nixpkgs-zsh-fzf-tab.url = "github:nixos/nixpkgs/8193e46376fdc6a13e8075ad263b4b5ca2592c03";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    ...
  }: let
    globals = {
      user = "danielng";
      macHostname = "danielng-mbp";
    };

    supportedSystems = ["x86_64-linux" "aarch64-darwin"];
    # A helper to generate attrset { x86_64-linux = ...; aarch64-darwin = ...; ... }
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    nixpkgsConfig = {allowUnfree = true;};
    pkgsForSystem = system:
      import nixpkgs {
        config = nixpkgsConfig;
        inherit system;
      };
  in {
    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

    # Build linux flake using:
    # $ home-manager switch --flake .#marigold
    packages = forAllSystems (system: let
      pkgs = pkgsForSystem system;
    in {
      homeConfigurations = {
        marigold = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [./profiles/marigold];
          extraSpecialArgs = {
            inherit globals;
            pkgs-zsh-fzf-tab =
              import inputs.nixpkgs-zsh-fzf-tab {system = system;};
          };
        };
      };
    });
    # Build darwin flake using:
    # $ darwin-rebuild switch --flake .#rose
    darwinConfigurations = {
      rose = import ./profiles/rose {inherit inputs globals nixpkgsConfig;};
    };

    # Development environment
    devShells = forAllSystems (system: let
      pkgs = pkgsForSystem system;
    in {
      # Frontend development
      # $ nix develop .#frontend -c $SHELL
      frontend = import ./dev/frontend.nix {inherit pkgs;};

      # Python development
      # $ nix develop .#python -c $SHELL
      python = import ./dev/python.nix {inherit pkgs;};

      # Go development
      # $ nix develop .#go -c $SHELL
      go = import ./dev/golang.nix {inherit pkgs;};

      # Java/Kotlin development
      # $ nix develop .#java -c $SHELL
      java = import ./dev/java.nix {inherit pkgs;};

      # Infrastructure development
      # $ nix develop .#devops -c $SHELL
      devops = import ./dev/devops.nix {inherit pkgs;};
    });
  };
}
