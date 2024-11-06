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

    nixpkgs-zsh-fzf-tab.url = "github:nixos/nixpkgs/8193e46376fdc6a13e8075ad263b4b5ca2592c03";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, nixvim, ... }:
    let
      nixpkgsConfig = {
        allowUnfree = true;
      };
      user = "danielng";
      hostname = "danielng-mbp";
      system = "aarch64-darwin";

      pkgs = import nixpkgs { 
        config.allowUnfree = true;
        system = system;
      };

      nixvimModule = {
        inherit pkgs;
        module = import ./nixvim-config;
        extraSpecialArgs = {};
      };
      nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule nixvimModule;
      nvimLib = nixvim.lib.${system};

    in
      {
      checks = {
        default = nvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#danielng-mbp
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;


        # Make all inputs available in imported files
        specialArgs = { inherit inputs; };

        modules = [ 
          ./darwin
          ({ pkgs, inputs, ... }: {
            nixpkgs.config = nixpkgsConfig;

            environment.systemPackages = [
              nvim
              # GUI apps
              pkgs.alacritty
              pkgs.mkalias
              pkgs.obsidian
              pkgs.appcleaner
            ];

            # The platform the configuration will be used on.
            nixpkgs.hostPlatform = system;

            system = {
              stateVersion = 5;
              configurationRevision = self.rev or self.dirtyRev or null;
            };

            # Set the home directory
            users.users.${user} = {
              home = "/Users/${user}";
              shell = pkgs.zsh;
            };

            networking = {
              computerName = hostname;
              hostName = hostname;
              localHostName = hostname;
            };

            nix = {
              # Enable flakes
              gc = {
                automatic = false;
                user = user;
              };

              settings = {
                allowed-users = [ user ];
                experimental-features = "flakes nix-command";
                warn-dirty = false;
              };
            };
          })
          home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs;
                pkgs-zsh-fzf-tab = import inputs.nixpkgs-zsh-fzf-tab { inherit system; };
              };
              users.${user} = { ...}:
                with inputs; {
                  imports = [
                    ./home-manager
                    ./shell
                  ];
                  home.username = user;
                  home.stateVersion = "24.05";
                };
            };
          }
          nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              # Install Homebew under the default prefix
              enable = true;

              # Apple Sillicon config
              enableRosetta = true;
              user = user;

              # Automatically migrate existing Homebew installations
              autoMigrate = true;
            };
          }
        ];
      };
    };
}

