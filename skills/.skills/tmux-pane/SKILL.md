---
name: tmux-pane
description: View the last N rows of output from a tmux pane
---

# Tmux Pane Viewer

View the contents of a specific tmux pane by capturing its last N rows.

## Arguments

- `$0` - Target pane in format "window.pane" (e.g., "1.2" for window 1, pane 2)
- `$1` - Number of rows to capture (e.g., "100")

## Instructions

1. Use the tmux `capture-pane` command to retrieve the pane contents:
   ```bash
   tmux capture-pane -t $0 -p -S -$1
   ```

2. Display the captured output to the user

3. If there's an error (e.g., pane doesn't exist), inform the user and suggest:
   - Running `tmux list-panes -a` to see all available panes
   - Checking if the tmux session is active

## Usage Examples

- `/tmux-pane 1.2 100` - View last 100 rows from window 1, pane 2
- `/tmux-pane 0.0 50` - View last 50 rows from window 0, pane 0
- `/tmux-pane 3.1 200` - View last 200 rows from window 3, pane 1

## Notes

- The `-S -$1` flag tells tmux to start capturing from N lines back
- The `-p` flag prints to stdout instead of saving to a buffer
- The `-t` flag specifies the target pane
