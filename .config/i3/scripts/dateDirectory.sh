#!/usr/bin/env bash
set -euo pipefail

# Check if there is a directory with "Year-Month", otherwise create one

if [ ! -d "$HOME/Pictures/Screenshots/$(date +"%Y-%m")" ]; then
	mkdir "$HOME/Pictures/Screenshots/$(date +"%Y-%m")"
fi
