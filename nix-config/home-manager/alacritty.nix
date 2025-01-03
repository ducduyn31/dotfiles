{ ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      font = let fontname = "JetBrainsMono Nerd Font"; in {
        normal = {
          family = fontname;
          style = "Bold";
        };
        bold = {
          family = fontname;
          style = "ExtraBold";
        };
        italic = {
          family = fontname;
          style = "ExtraLight";
        };
        size = 17;
      };
      window = {
        opacity = 0.75;
        padding = {
          x = 5;
          y = 0;
        };
        decorations = "Buttonless";
        startup_mode = "Maximized";
      };
      colors = {
        transparent_background_colors = true;
      };
      selection.save_to_clipboard = true;
    };
  };
}
