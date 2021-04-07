#!/usr/bin/env bash
set -euo pipefail

while [ true ]; do
	if [ $(date +%H) -eq 18 ]; then
		notify-send -i ~/bin/pictures/doctor.jpg -u critical "FUTURE SELF" "Do not forget to do your anki cards for today"
		break
	fi
	sleep 360
done
