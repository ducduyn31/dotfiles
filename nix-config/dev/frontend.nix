{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = [ pkgs.pnpm pkgs.fnm pkgs.bun pkgs.supabase-cli pkgs.zsh ];
  shellHook = ''
    echo "
    Welcome to the frontend development environment!
    You have access to the following tools:
    - pnpm: $(pnpm --version)
    - fnm: $(fnm --version)
    - bun: $(bun --version)
    - and more!

    Default shell is bash. To switch to zsh, run 'zsh'.
    "
  '';
}
