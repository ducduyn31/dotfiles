{ ... }: {
  home.file.aerospace = {
    target = ".aerospace.toml";
    text = ''
      enable-normalization-flatten-containers = false
      enable-normalization-opposite-orientation-for-nested-containers = false

      [gaps]
      inner.horizontal = 0
      inner.vertical = 0
      outer.left = 0
      outer.right = 0
      outer.top = 0
      outer.bottom = 0

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

      alt-1 = 'workspace 1'
      alt-2 = 'workspace 2'
      alt-3 = 'workspace 3'
      alt-4 = 'workspace 4'
      alt-5 = 'workspace 5'

      alt-shift-1 = 'move-node-to-workspace 1'
      alt-shift-2 = 'move-node-to-workspace 2'
      alt-shift-3 = 'move-node-to-workspace 3'
      alt-shift-4 = 'move-node-to-workspace 4'
      alt-shift-5 = 'move-node-to-workspace 5'

      alt-shift-c = 'reload-config'

      [workspace-to-monitor-force-assignment]
      1 = 'main'
      2 = 'main'
      3 = 'main'
      4 = 'main'
      5 = ['msi', 'dell', 'builtin', 'secondary', 'main']

      [[on-window-detected]]
      if.app-name-regex-substring = 'alacritty'
      run = 'move-node-to-workspace 2'

      [[on-window-detected]]
      if.app-name-regex-substring = 'discord'
      run = 'move-node-to-workspace 4'

      [[on-window-detected]]
      if.app-name-regex-substring = 'arc'
      run = 'move-node-to-workspace 1'
    '';
  };
}
