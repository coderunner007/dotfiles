#!/bin/bash

xfce4-screenshooter -w -o cat > ~/Pictures/$(date +Screenshot%Y_%m_%d_%H_%M_%S.png)
notify-send -t 2500  -a "Screenshoter" "$(date +Screenshot%Y_%m_%d_%H_%M_%S.png) saved at ~/Pictures"
