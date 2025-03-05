{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = [
    pkgs.pnpm
    pkgs.fnm
    pkgs.bun
    pkgs.supabase-cli
    pkgs.zsh
    pkgs.turbo
  ];
  nativeBuildInputs = [ pkgs.playwright-driver.browsers ];
  shellHook = ''
    export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
    export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
    echo "
    Welcome to the frontend development environment!
    You have access to the following tools:
    - pnpm: $(pnpm --version)
    - fnm: $(fnm --version)
    - bun: $(bun --version)
    - and more!

    **Note**: Playwright is currently broken on Nix. There is a work around
    to use playwright by setting:

    nativeBuildInputs = [ pkgs.playwright-driver.browsers ];
    ...
    shellHook = \"
      export PLAYWRIGHT_BROWSERS_PATH=$\{pkgs.playwright-driver.browsers\}
      export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
    \";

    However, this only works for Chromium. So you will have to install these libraries
    manually if you want to use playwright.
    "

    # Start zsh if not already in zsh
    if [ -z "$ZSH_VERSION" ]; then
      exec zsh
    fi
  '';
}
