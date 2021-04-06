#!/usr/bin/env bash
set -euo pipefail

# Loops for X seconds and turns off urgent-notifications from i3

end=$((SECONDS + 120))

while [ $SECONDS -lt $end ]; do
	for win in $(wmctrl -l | awk -F' ' '{print $1}'); do
		wmctrl -i -r $win -b remove,demands_attention
	done
done
