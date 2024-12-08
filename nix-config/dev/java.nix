{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = [
    pkgs.gradle
    pkgs.kotlin
    pkgs.ktlint

  ];
  shellHook = ''
    echo "
    Welcome to the Java development environment!
    You have access to the following tools:
    - gradle: $(gradle --version | grep Gradle)
    - kotlin: $(kotlin -version)
    - ktlint: $(ktlint --version)
    - and more!

    Default shell is bash. To switch to zsh, run 'zsh'.
    "
  '';
}
