{...}: {
  programs.bash = {
    enable = true;

    profileExtra = ''
      # Set up volta — strip resolved tool paths so shims take priority
      # (volta injects tools/image paths when launching node apps like Claude Code)
      if command -v volta &> /dev/null; then
        export VOLTA_HOME="$HOME/.volta"
        PATH="$(echo "$PATH" | tr ':' '\n' | grep -v '\.volta/tools/image' | tr '\n' ':' | sed 's/:$//')"
        export PATH="$VOLTA_HOME/bin:$PATH"
      fi
    '';
  };
}
