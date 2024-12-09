# Nix Configuration

This configuration is tailored to my personal preferences and is intended for macOS on my Mac M1.

## Setup Nix

### 1. Install Nix

To install Nix on MacOS, run the following command in your terminal:

```bash
curl -L https://nixos.org/nix/install | sh
```

Follow the on-screen instructions to complete the installation. Once installed, you need to configure your shell environment. You can do this by running:

```bash
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

Alternatively, simply open a new terminal, and the configuration will be automatically sourced.

### 2. Clone this repository

Clone this repository to your home directory or another location of your choice to access the necessary configuration files:

```bash
git clone git@github.com:ducduyn31/dotfiles.git
```

### 3.1 Install `nix-darwin` (If you are using macOS)

`nix-darwin` is a tool that allows you to manage macOS settings using Nix. To install it, run the following command:

```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.dotfiles/nix-config#rose
```

After running this command, either source the session again or open a new terminal.

**Note:** The configuration file references a profile named daniel. You may need to modify the flake.nix file to match your setup before running the command.

### 3.2 Install `home-manager` (If you are using non-nix system)

`home-manager` lets you manage your user environment using Nix. You can install it via standalone mode for non-nix system:

```bash
# Adding the channel to download home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# Installing home-manager
nix-shell '<home-manager>' -A install
```

**Note**: This will create a home.nix file in your home directory. But we will use the flake.nix file in this repository to manage the home-manager configuration.

You will then need to enable flake experimental features in your Nix configuration. To do this, add the following line to your `~/.config/nix/nix.conf` file:

```bash
experimental-features = nix-command flakes
```

### 4. Switch to the new configuration

After installing `nix-darwin` or `home-manager`, you can switch to the new configuration by running the following command:

```bash
darwin-rebuild switch --flake ~/.dotfiles/nix-config#rose
```

or

```bash
home-manager switch --flake ~/.dotfiles/nix-config#marigold
```

**NOTE**: Make sure you are on the correct user specified in the flake.nix file.

# Additional Documentation

| Document                                                       | Description                                         |
| -------------------------------------------------------------- | --------------------------------------------------- |
| [UNINSTALLING-INSTRUCTIONS](docs/UNINSTALLING-INSTRUCTIONS.md) | Instructions for uninstalling Nix from your system. |
