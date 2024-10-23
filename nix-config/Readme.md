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

### 3. Install `nix-darwin`

`nix-darwin` is a tool that allows you to manage macOS settings using Nix. To install it, run the following command:

```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.dotfiles/nix-config#daniel
```

After running this command, either source the session again or open a new terminal.

**Note:** The configuration file references a profile named daniel. You may need to modify the flake.nix file to match your setup before running the command.


# Additional Documentation

| Document                                                       | Description                                         |
|----------------------------------------------------------------|-----------------------------------------------------|
| [UNINSTALLING-INSTRUCTIONS](docs/UNINSTALLING-INSTRUCTIONS.md) | Instructions for uninstalling Nix from your system. |
