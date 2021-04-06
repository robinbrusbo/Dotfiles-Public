#!/usr/bin/env bash
set -euo pipefail

# Copy paste code cause I'm too lazy :D

red="\e[0;31m"
green="\e[0;32m"

while read -r line; do
	echo -e $red$line
	read -r line
	echo -e $red$line
	echo ""

	read -r line
	echo -e $green$line
	read -r line
	echo -e $green$line
	echo ""
done
