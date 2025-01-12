# MacOS Configuration

This is the folder for configuration for software that requires constant changes, such as Neovim.
This is due to the fact that I don't want to rebuild nix generation every time I change a setting in Neovim.

It utilize stow to manage the configuration files.

To install the configuration, run the following command:

```bash
stow -t ~ -v -d .
```
