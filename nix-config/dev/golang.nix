{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = [
    pkgs.go
    pkgs.gotestsum
    pkgs.cue
    pkgs.golangci-lint

  ];
  shellHook = ''
    echo "
    Welcome to the Golang development environment!
    You have access to the following tools:
    - go: $(go version)
    - cue: $(cue version)
    - and more!

    Default shell is bash. To switch to zsh, run 'zsh'.
    "
  '';
}
