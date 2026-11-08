-- Keep Rex pane creation consistent with tmux, Herdr, and Neovim.

-- Direct macOS shortcuts.
rex.bind("cmd+[Backslash]", "pane.split", { direction = "right" })
rex.bind("cmd+-", "pane.split", { direction = "down" })

-- tmux/Herdr-compatible prefix sequences.
rex.bind("ctrl+s>[Backslash]", "pane.split", { direction = "right" })
rex.bind("ctrl+s>-", "pane.split", { direction = "down" })
rex.bind("ctrl+s>c", "client.tab.new")
rex.bind("ctrl+s>s", "client.sidebar.toggle")
rex.bind("ctrl+s>a", "client.sidebar.activity.toggle")
rex.bind("ctrl+s>z", "pane.zoom")
rex.bind("ctrl+s>r", "client.config.reload")

-- Match the tmux workspace-picker shortcut with Rex's native session picker.
-- Use `rs` when you need to create a session from the project/worktree list.
rex.bind("ctrl+f", "session.switch")

-- Open the project/worktree picker without dedicating a permanent tab to it.
-- `rex-sessionizer` creates or selects the chosen persistent workspace; the
-- floating terminal then exits and Rex removes the layer. Escape from fzf
-- leaves the picker open only when it exits immediately, so its error remains
-- visible instead of disappearing.
local function project_picker()
  return rex.session.new_layer{
    bounds = { 0.12, 0.16, 0.76, 0.58 },
    focus = true,
    layout = {
      block = {
        flavor = "com.superlogical.terminal.shell",
        label = "Project picker",
        options = {
          shell = "none",
          command = { "/bin/zsh", "-lc", "rex-sessionizer" },
          exit = { on_completion = true },
        },
      },
    },
  }
end

rex.bind("ctrl+s>p", project_picker)

-- Move between Rex panes without a prefix, but pass the key through when
-- Neovim owns the terminal so it can navigate its own split first.
local terminal = "com.superlogical.terminal"
local function focus_or_forward(direction)
  return function(ctx)
    local process = rex.block.call(terminal, "process", { block_id = ctx.block_id })
    if process and process.foreground and process.foreground.name == "nvim" then
      return false
    end

    local result = rex.session.focus_direction{
      block_id = ctx.block_id,
      direction = direction,
    }
    return result ~= nil
  end
end

rex.bind("ctrl+h", focus_or_forward("left"))
rex.bind("ctrl+j", focus_or_forward("down"))
rex.bind("ctrl+k", focus_or_forward("up"))
rex.bind("ctrl+l", focus_or_forward("right"))

-- Keep the prefixed fallback available too.
rex.bind("ctrl+s>h", "pane.focus.left")
rex.bind("ctrl+s>j", "pane.focus.down")
rex.bind("ctrl+s>k", "pane.focus.up")
rex.bind("ctrl+s>l", "pane.focus.right")
