# Nix Configuration

## Setup Nix

### 1. Install Nix

To install Nix on MacOS, run the following command in your terminal:

```bash
curl -L https://nixos.org/nix/install | sh
```

Follow the on-screen instructions to complete the installation. After installation, ensure that your shell is properly configured by running:

```bash
. ~/.nix-profile/etc/profile.d/nix.sh
```

### 2. Clone this repository

Next, clone this repository to your home directory (or a location of your choice):

```bash
git clone git@github.com:ducduyn31/dotfiles.git
```

### 3. Set Up Nix Configurations

Navigate to the `nix-config` folder and link the Nix configuration files to the appropriate locations on your system:

```bash
cd ~/.dotfiles/nix-config
```

You can use the following commands to create symbolic links to these configuration files:

```bash
ln -s ~/.dotfiles/nix-config/config.nix ~/.config/nixpkgs/config.nix
```

Make sure to modify the paths as per your directory structure if needed.

## Uninstalling Nix

If you need to uninstall Nix from your system, follow these steps:

### 1. Edit `/etc/zshrc`, `/etc/zsh/zshrc`,  `/etc/profile.d/nix.sh`, `/etc/bashrc`, and `/etc/bash.bashrc` and remove these lines:

```
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```

### 2. Stop and remove the Nix daemon services:

```bash
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist
sudo rm /Library/LaunchDaemons/org.nixos.darwin-store.plist
```

### 3. Remove the `nixbld` group and the `_nixbuildN` users:

```bash
sudo dscl . -delete /Groups/nixbld
for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete /Users/$u; done
```

### 4. Remove any lines that look like this in fstab using:

```bash
sudo vifs
```

Look for lines like this and delete:

```
UUID=<uuid> /nix apfs rw,noauto,nobrowse,suid,owners
```

### 5. Remove synthetic.conf

```bash
sudo rm /etc/synthetic.conf
```

### 6. Remove the files Nix added to your system:

```bash
sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels
```

### 7. Remove the Nix Store volume:

```bash
sudo diskutil apfs deleteVolume /nix
```




