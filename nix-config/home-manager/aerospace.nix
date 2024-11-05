{ ... }: {
  home.file.aerospace = {
    target = ".aerospace.toml";
    text = ''
      enable-normalization-flatten-containers = false
      enable-normalization-opposite-orientation-for-nested-containers = false

      [gaps]
      inner.horizontal = 15
      inner.vertical = 15
      outer.left = 15
      outer.right = 15
      outer.top = 15
      outer.bottom = 15

      [mode.main.binding]
      alt-j = 'focus down'
      alt-k = 'focus up'
      alt-h = 'focus left'
      alt-l = 'focus right'

      alt-shift-j = 'move down'
      alt-shift-k = 'move up'
      alt-shift-h = 'move left'
      alt-shift-l = 'move right'

      alt-f = 'fullscreen'
      alt-d = 'layout h_accordion tiles' # 'layout tabbed' in i3
      alt-shift-space = 'layout floating tiling'

      alt-q = 'workspace 1'
      alt-w = 'workspace 2'
      alt-e = 'workspace 3'
      alt-r = 'workspace 4'
      alt-t = 'workspace 5'

      alt-shift-q = 'move container to workspace 1'
      alt-shift-w = 'move container to workspace 2'
      alt-shift-e = 'move container to workspace 3'
      alt-shift-r = 'move container to workspace 4'
      alt-shift-t = 'move container to workspace 5'

      alt-shift-c = 'reload'

      [workspace-to-monitor-force-assignment]
      1 = 'main'
      2 = 'main'
      3 = 'main'
      4 = 'main'
      5 = ['builtin' 'secondary', 'main']

      [[on-window-detected]]
      if.app-name-regex-substring = 'alacritty'
      run = 'move-node-to-workspace 2'
    '';
  };
}
