local wezterm = require('wezterm')
local config = wezterm.config_builder()
config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }


local function move_pane(key, direction)
  return {
    key = key,
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection(direction),
  }
end

config.keys = {
  {
    key = '\\',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  move_pane('j', 'Down'),
  move_pane('k', 'Up'),
  move_pane('h', 'Left'),
  move_pane('l', 'Right'),
}



config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.color_scheme = 'Catppuccin Mocha'
config.font_size = 11.0
config.background = {
}
return config
