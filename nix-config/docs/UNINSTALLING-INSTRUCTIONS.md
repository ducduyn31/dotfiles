# Uninstall

This guide provides detailed instructions for uninstalling both nix-darwin and Nix from your macOS system. Follow the steps below to ensure a clean removal.

## Uninstalling Home Manager standalone (If you are using non-nix system)

To uninstall Home Manager standalone, run the following command:

```bash
nix run home-manager --extra-experimental-features "nix-command flakes" -- uninstall
```

This command will uninstall Home Manager but will leave the home.nix untouched. You can remove the home.nix file manually in ~/.config/home-manager if you want to remove the configuration.

## Uninstalling nix-darwin

To uninstall nix-darwin, simply run:

```bash
nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
```

## Uninstalling Nix from macOS

If you need to completely uninstall Nix from your system, follow these steps:

### 1. Edit `/etc/zshrc`, `/etc/zsh/zshrc`, `/etc/profile.d/nix.sh`, `/etc/bashrc`, and `/etc/bash.bashrc` and remove these lines:

```
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```

### 2. Stop and remove the Nix daemon services:

Stop and remove the Nix daemon services by running:

```bash
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist
sudo rm /Library/LaunchDaemons/org.nixos.darwin-store.plist
```

### 3. Remove the `nixbld` group and the `_nixbuildN` users:

Remove the nixbld group and associated users:

```bash
sudo dscl . -delete /Groups/nixbld
for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete /Users/$u; done
```

### 4. Remove any lines that look like this in fstab using:

Open the fstab file using:

```bash
sudo vifs
```

Look for lines like the following and delete them:

```
UUID=<uuid> /nix apfs rw,noauto,nobrowse,suid,owners
```

### 5. Remove synthetic.conf

Delete the `synthetic.conf` file:

```bash
sudo rm /etc/synthetic.conf
```

### 6. Remove the files Nix added to your system:

Remove all files and directories added by Nix:

```bash
sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels
```

### 7. Remove the Nix Store volume:

Finally, delete the Nix Store volume:

```bash
sudo diskutil apfs deleteVolume /nix
```

**Note:** After reboot, the /nix folder will be automatically remoeved

## Uninstalling Nix from Linux

If you need to uninstall Nix from your Linux system, follow these steps:

### 1. Remove the Nix daemon services:

Stop and remove the Nix daemon services by running:

```bash
sudo systemctl stop nix-daemon.service
sudo systemctl disable nix-daemon.socket nix-daemon.service
sudo systemctl daemon-reload
```

### 2. Remove the files Nix added to your system:

```bash
sudo rm -rf /etc/nix /etc/profile.d/nix.sh /etc/tmpfiles.d/nix-daemon.conf /nix ~root/.nix-channels ~root/.nix-defexpr ~root/.nix-profile
```

### 3. Remove build users and groups:

```bash
for i in $(seq 1 32); do
  sudo userdel nixbld$i
done
sudo groupdel nixbld
```

### 4. Remove the reference in shell configuration:

You may also be referenced to Nix in your shell configuration. Remove anything related to nix in these files:

```
/etc/bash.bashrc
/etc/bashrc
/etc/profile
/etc/zsh/zshrc
/etc/zshrc
```
