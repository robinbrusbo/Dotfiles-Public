#!/usr/bin/env bash
set -euo pipefail

yay -S --noconfirm gimp
yay -S --noconfirm anki
yay -S --noconfirm droidcam
yay -S --noconfirm chromium
yay -S --noconfirm ksysguard
yay -S --noconfirm spectacle
yay -S --noconfirm truckersmp-cli
yay -S --noconfirm zoom
yay -S --noconfirm polychromatic
yay -S --noconfirm xf86-input-wacom

# auto login
# ändra också marhaba /etc/lightdm/lightdm.conf owo
sudo groupadd -r autologin
sudo gpasswd -a robban autologin

yay -Rns --noconfirm firefox
yay -Rns --noconfirm pulseeffects-legacy
