#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

echo "---" | tee -a /tmp/polybar1.log
polybar barright 2>&1 | tee -a /tmp/polybar-barright.log & 
disown

polybar barleft 2>&1 | tee -a /tmp/polybar-barleft.log &
disown

echo "Bars launched..."
