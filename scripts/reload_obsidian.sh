#!/bin/bash

# Store the ID of the previously focused window
PREVIOUS_WINDOW_ID=$(swaymsg -t get_tree | jq '.. | select(.focused? == true) | .id' | head -n 1)

# Focus the Obsidian window using swaymsg
if swaymsg [instance='obsidian'] focus; then
    sleep 1
    # Press Ctrl+R
    wtype -M ctrl r -m ctrl
    echo "Reload command sent to Obsidian."

    # If there was a previously focused window, focus it again
    if [ -n "$PREVIOUS_WINDOW_ID" ]; then
        # echo "Restoring focus to the previously focused window: $PREVIOUS_WINDOW_ID"
        swaymsg "[con_id=$PREVIOUS_WINDOW_ID]" focus
    fi
else
    echo "nothing to focus"
fi
