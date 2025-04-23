{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = [
    pkgs.pyenv
    pkgs.python3
    pkgs.poetry
    pkgs.uv
  ];
  shellHook = ''
    echo "
    Welcome to the Python development environment!
    You have access to the following tools:
    - pyenv: $(pyenv --version)
    - python3: $(python3 --version)
    - poetry: $(poetry --version)
    - and more!

    Default shell is bash. To switch to zsh, run 'zsh'.
    "
  '';
}
