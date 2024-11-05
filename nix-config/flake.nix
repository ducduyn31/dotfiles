{
  description = "Daniel's Darwin system flake";

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
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, config, ... }: {
	  
	  nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ 
		# Must have
        pkgs.vim
        pkgs.neovim
        pkgs.tmux
		pkgs.starship
		
		# Utils for cli
        pkgs.tree
		pkgs.zenith
		pkgs.nmap

		# Java tools
		pkgs.maven

		# Javascript
		pkgs.pnpm
		pkgs.supabase-cli

		# Infra tools
		pkgs.terraform
		pkgs.terragrunt
		pkgs.kubernetes-helm

		# GUI apps
        pkgs.mkalias
		pkgs.obsidian
      ];

      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Add a shell alias for darwin-rebuild switch.
      environment.shellAliases = {
        dswitch = "darwin-rebuild switch --flake ~/.dotfiles/nix-config#general";
      };

	  # Enable Home Manager as a Nix module.
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.danielng = import ./danielng.nix;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#general
    darwinConfigurations."general" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."daniel".pkgs;
  };
}

