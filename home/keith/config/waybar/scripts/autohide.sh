#!/bin/bash

# NOTE: Your waybar config must have "on-sigusr1": "toggle" for this script to work

# Threshold to show the bar
SHOW_THRESHOLD=1

# Lower bound to hide the bar
HIDE_THRESHOLD=56

# Time delay before hiding the bar
HIDE_DELAY=0.3

# This script assumes waybar is running and showing.
sleep 0.5
pkill -SIGUSR1 waybar

while true; do
  Y_POS=$(hyprctl cursorpos | awk -F',' '{print $2}' | tr -d ' ')

  if [ "$Y_POS" -le "$SHOW_THRESHOLD" ]; then

    pkill -SIGUSR2 waybar

    # Sleep until cursor moves below threshold
    while [ "$Y_POS" -le "$HIDE_THRESHOLD" ]; do
      sleep 0.2
      Y_POS=$(hyprctl cursorpos | awk -F',' '{print $2}' | tr -d ' ')
    done

    sleep $HIDE_DELAY

    pkill -SIGUSR1 waybar

  fi

  sleep 0.2
done