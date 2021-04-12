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
yay -S --noconfirm pavucontrol
yay -S --noconfirm ddnet
yay -S --noconfirm cmake
yay -S --noconfirm zathura zathura-pdf-poppler
yay -S --noconfirm ansiweather
yay -S --noconfirm flatpak

# auto login
# ändra också marhaba /etc/lightdm/lightdm.conf owo
sudo groupadd -r autologin
sudo gpasswd -a robban autologin

yay -Rns --noconfirm firefox
yay -Rns --noconfirm pulseeffects-legacy
yay -Rns --noconfirm syncthing
