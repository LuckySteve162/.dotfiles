#!/bin/bash

# Start swww if not already running
pgrep -x swww > /dev/null || swww init

# Define wallpapers
wallpapers=(
  ~/.dotfiles/sww/cozyknuckle.png
  ~/.dotfiles/sww/rainworld1.png
  ~/.dotfiles/sww/rainworld2.png
  ~/.dotfiles/sww/kenshi1.png
)

# Infinite loop
while true; do
  for wp in "${wallpapers[@]}"; do
    swww img "$wp" --transition-type any --transition-duration 1
    sleep 60  # Wait 60 seconds
  done
done