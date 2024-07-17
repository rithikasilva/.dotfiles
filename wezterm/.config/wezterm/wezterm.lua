local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }

local function is_inside_vim(pane)
  return pane:get_user_vars().IS_NVIM == 'true'
end

local function is_outside_vim(pane) return not is_inside_vim(pane) end

local function bind_if(cond, key, mods, action)
  local function callback(win, pane)
    if cond(pane) then
      win:perform_action(action, pane)
    else
      win:perform_action(wezterm.action.SendKey({ key = key, mods = mods }), pane)
    end
  end

  return { key = key, mods = mods, action = wezterm.action_callback(callback) }
end


config.keys = {
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
  bind_if(is_outside_vim, 'h', 'CTRL', wezterm.action.ActivatePaneDirection('Left')),
  bind_if(is_outside_vim, 'l', 'CTRL', wezterm.action.ActivatePaneDirection('Right')),
  bind_if(is_outside_vim, 'k', 'CTRL', wezterm.action.ActivatePaneDirection('Up')),
  bind_if(is_outside_vim, 'j', 'CTRL', wezterm.action.ActivatePaneDirection('Down')),
  -- { key = "h", mods = "CTRL", action = wezterm.action { EmitEvent = "move-left" } },
  -- { key = "j", mods = "CTRL", action = wezterm.action { EmitEvent = "move-down" } },
  -- { key = "k", mods = "CTRL", action = wezterm.action { EmitEvent = "move-up" } },
  -- { key = "l", mods = "CTRL", action = wezterm.action { EmitEvent = "move-right" } },
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
