{
  inputs,
  nixpkgsConfig,
  globals,
}:
with inputs;
  nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";

    # Make all inputs available in imported files
    specialArgs = {inherit inputs;};

    modules = [
      ../../darwin
      ({
        pkgs,
        inputs,
        ...
      }: {
        nixpkgs.config = nixpkgsConfig;

        environment = {
          systemPackages = [
            # GUI apps
            pkgs.mkalias
            pkgs.obsidian
            pkgs.appcleaner
          ];
          etc = {
            "containers/containers.conf.d/99-gvproxy-path.conf".text = ''
              [engine]
              helper_binaries_dir = ["${pkgs.gvproxy}/bin"]
            '';
          };
        };

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
          gc = {automatic = false;};

          settings = {
            allowed-users = [globals.user];
            experimental-features = "flakes nix-command";
            warn-dirty = false;
            download-buffer-size = 134217728; # 128 MB
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
              import inputs.nixpkgs-zsh-fzf-tab {system = "aarch64-darwin";};
          };
          users.${globals.user} = {pkgs, config, ...}:
            with inputs; {
              imports = [
                ../../home-manager
                ../../shell
                inputs.zen-browser.homeModules.default
              ];
              home.username = globals.user;
              home.stateVersion = "25.05";

              # For this profile, provide the python, frontend, and devops packages
              # without going to devshell.
              home.packages = let
                gdk =
                  pkgs.google-cloud-sdk.withExtraComponents
                  (with pkgs.google-cloud-sdk.components; [gke-gcloud-auth-plugin]);
              in
                with pkgs; [
                  # Java
                  jdk21_headless

                  # Javascript
                  pnpm
                  volta
                  bun
                  supabase-cli
                  codex

                  # Python
                  pyenv
                  python3
                  poetry
                  uv

                  # Security
                  sherlock
                  exiftool

                  # Golang
                  go
                  air
                  gotestsum
                  delve
                  cue
                  golangci-lint
                  redocly
                  go-mockery
                  go-swag

                  # Rust
                  rustc
                  alejandra
                  watchexec
                  rustup

                  # Nix
                  nixd

                  # Infrastructure
                  awscli2
                  azure-cli
                  pulumi
                  pulumiPackages.pulumi-nodejs
                  ssm-session-manager-plugin
                  tenv # Including terraform and terragrunt
                  trivy
                  kubectl
                  k9s
                  stern
                  kubectx
                  tflint
                  docker-compose
                  gdk

                  # Databases
                  riot-redis

                  # Streaming
                  keycastr # Visualize keystrokes
                  perl
                ];

              programs = {
                go = {
                  enable = true;
                };

                zen-browser.enable = true;
              };

              home.sessionVariables = {
                GOPATH = "${config.home.homeDirectory}/go";
                GOBIN = "${config.home.homeDirectory}/go/bin";
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
