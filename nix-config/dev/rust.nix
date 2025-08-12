{pkgs, ...}:
pkgs.mkShell {
  buildInputs = [
    pkgs.rustc
    pkgs.cargo
    pkgs.rustfmt
    pkgs.clippy
    pkgs.rust-analyzer
    pkgs.alejandra
  ];
  shellHook = ''
    echo "
    Welcome to the Rust development environment!
    You have access to the following tools:
    - rustc: $(rustc --version)
    - cargo: $(cargo --version)
    - alejandra: $(alejandra --version)
    - and more!

    Default shell is bash. To switch to zsh, run 'zsh'.
    "
  '';
}
