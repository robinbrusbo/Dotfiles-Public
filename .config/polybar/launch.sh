#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

export TRAY_POS=right
# choose location for temperature
resolution=$(xdpyinfo | grep -oP 'dimensions:\s+\K\S+')
if [[ $resolution == 13* ]]; then
	export MOUNT_PATH="/"
	export HWMON_PATH=/sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input
else
	export MOUNT_PATH="/home"
	export HWMON_PATH=/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input
fi

# polybar bar on both monitors
if type "xrandr"; then
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		MONITOR=$m polybar --reload main -c "$DIR"/config.ini &
		unset TRAY_POS
	done
else
	polybar --reload main -c "$DIR"/config.ini &
fi

# Launch the bar
# polybar -q main -c "$DIR"/config.ini &
