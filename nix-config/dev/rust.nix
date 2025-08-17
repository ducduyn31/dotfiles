{pkgs, ...}:
pkgs.mkShell {
  buildInputs = [
    pkgs.rustc
    pkgs.rustup
    pkgs.alejandra
    pkgs.watchexec
  ];
  shellHook = ''
    echo "
    Welcome to the Rust development environment!
    You have access to the following tools:
    - rustc: $(rustc --version)
    - alejandra: $(alejandra --version)
    - and more!

    Default shell is bash. To switch to zsh, run 'zsh'.
    "
  '';
}
