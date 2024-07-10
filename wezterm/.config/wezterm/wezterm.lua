local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }

local function is_vim(pane)
  local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
  return process_name == 'nvim' or process_name == 'vim'
end

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end



config.keys = {
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),
  {
    mods   = "LEADER",
    key    = "-",
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    mods   = "LEADER",
    key    = "\\",
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  { key = "h", mods = "CTRL", action = wezterm.action { ActivatePaneDirection = "Left" } },
  { key = "j", mods = "CTRL", action = wezterm.action { ActivatePaneDirection = "Down" } },
  { key = "k", mods = "CTRL", action = wezterm.action { ActivatePaneDirection = "Up" } },
  { key = "l", mods = "CTRL", action = wezterm.action { ActivatePaneDirection = "Right" } },
  {
    key = 'z',
    mods = 'CTRL',
    action = wezterm.action.TogglePaneZoomState,
  },

  {
    key = 'Enter',
    mods = 'LEADER',
    action = wezterm.action.ActivateCopyMode
  },
}


config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.color_scheme = 'Catppuccin Mocha'
return config
