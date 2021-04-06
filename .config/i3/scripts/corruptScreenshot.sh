#!/usr/bin/env bash
set -euo pipefail

dir=$HOME/Pictures/Screenshots/$(date +%Y-%m)

# Wait for the user to finish taking the picture
sleep 15

# Delete aborted screenshots
for filename in $dir/*.png; do
	if grep -q "screenshot aborted" $filename; then
		rm $filename
	fi
done
