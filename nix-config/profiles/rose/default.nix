{ inputs, nixpkgsConfig, globals, nvim }:

with inputs;
nix-darwin.lib.darwinSystem {
  system = "aarch64-darwin";

  # Make all inputs available in imported files
  specialArgs = { inherit inputs; };

  modules = [
    ../../darwin
    ({ pkgs, inputs, ... }: {
      nixpkgs.config = nixpkgsConfig;

      environment.systemPackages = [
        # nvim
        # GUI apps
        pkgs.alacritty
        pkgs.mkalias
        pkgs.obsidian
        pkgs.appcleaner
      ];

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      system = {
        stateVersion = 5;
        configurationRevision = self.rev or self.dirtyRev or null;
      };

      # Set the home directory
      users.users.${globals.user} = {
        home = "/Users/${globals.user}";
        shell = pkgs.zsh;
      };

      networking = {
        computerName = globals.macHostname;
        hostName = globals.macHostname;
        localHostName = globals.macHostname;
      };

      nix = {
        # Enable flakes
        gc = {
          automatic = false;
          user = globals.user;
        };

        settings = {
          allowed-users = [ globals.user ];
          experimental-features = "flakes nix-command";
          warn-dirty = false;
        };
      };
    })
    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          inherit inputs;
          pkgs-zsh-fzf-tab =
            import inputs.nixpkgs-zsh-fzf-tab { system = "aarch64-darwin"; };
        };
        users.${globals.user} = { pkgs, ... }:
          with inputs; {
            imports = [ ../../home-manager ../../shell ];
            home.username = globals.user;
            home.stateVersion = "24.11";

            # For this profile, provide the python, frontend, and devops packages
            # without going to devshell.
            home.packages = [
              # Java
              pkgs.jdk21_headless

              # Javascript
              pkgs.pnpm
              pkgs.turbo
              pkgs.fnm
              pkgs.bun
              pkgs.supabase-cli

              # Python
              pkgs.pyenv
              pkgs.python3
              pkgs.poetry

              # Golang
              pkgs.go
              pkgs.air
              pkgs.gotestsum
              pkgs.delve
              pkgs.cue
              pkgs.golangci-lint
              pkgs.redocly
              pkgs.go-mockery
              pkgs.go-swag

              # Infrastructure
              pkgs.terraform
              pkgs.terragrunt
              pkgs.kubectl
              pkgs.tflint

              # Streaming
              pkgs.keycastr # Visualize keystrokes
            ];

            programs = {
              go = {
                enable = true;
                goPath = "go";
                goBin = "go/bin";
                goPrivate = [ ];
              };
            };
          };
      };
    }
    nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        # Install Homebew under the default prefix
        enable = true;

        # Apple Sillicon config
        enableRosetta = true;
        user = globals.user;

        # Automatically migrate existing Homebew installations
        autoMigrate = true;
      };
    }
  ];
}
