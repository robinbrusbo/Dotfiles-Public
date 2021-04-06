#!/usr/bin/env bash
set -euo pipefail

read -p "Updating system? [y/n] "
updating=$REPLY
read -p "Do you have an Nvidia GPU? [y/n] "
nvidia=$REPLY
read -p "Are you installing on a laptop? [y/n] "
laptop=$REPLY
read -p "Are you going to be playing games on your computer? [y/n] "
gaming=$REPLY

if [[ ! $updating =~ ^[Yy]$ ]]; then
	# Enable locale.gen
	echo "en_GB.UTF-8 UTF-8
    en_US.UTF-8 UTF-8" >>locale.gen
	sudo mv locale.gen /etc/locale.gen
	sudo locale-gen

	# Enable multilib repository
	echo "[multilib]
    Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
	sudo pacman -Syu --noconfirm

	# Sync time on boot
	echo "timedatectl set-ntp true" | sudo tee -a /etc/rc.local

	# Install yay, main package manager
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin
	makepkg -si --noconfirm
	cd ..
	rm -rf yay-bin
fi

yay -S --noconfirm clamav

# yay -S --noconfirm pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol pulseeffects
yay -S --noconfirm pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseeffects-legacy

# TODO Backup the home directory
yay -S --noconfirm rsync grsync

# TODO Backup the root directory
yay -S --noconfirm timeshift

# Sync files between computers
yay -S --noconfirm syncthing
sudo systemctl enable syncthing@$USER.service

yay -S --noconfirm bluez bluez-utils blueman
sudo systemctl enable bluetooth.service

yay -S --noconfirm firefox

yay -S --noconfirm flameshot simplescreenrecorder peek vlc

# Create screenshots directory if it doesn't exist
if [ -z "$(ls -A $HOME/Pictures/Wallpapers)" ]; then
    mkdir -p $HOME/Pictures/Screenshots
fi

# In case the video size gets a bit big...
yay -S --noconfirm handbrake

# Webcam preview
yay -S --noconfirm cheese

# Alternative to paint.net
yay -S --noconfirm pinta

# Noise suppression
yay -S --noconfirm noisetorch-bin

# Taking pictures in org-mode
yay -S --noconfirm scrot

# Download videos
yay -S --noconfirm clipgrab

# Configure mouse settings
yay -S --noconfirm piper

yay -S --noconfirm lightdm gdk-pixbuf2
sudo systemctl enable lightdm

# Greeter/theme for lightdm
yay -S --noconfirm lightdm-gtk-greeter
# yay -S --noconfirm lightdm-webkit-theme-aether

# Fix black screen if computer boots too fast
echo "[LightDM]
logind-check-graphical=true
run-directory=/run/lightdm

[Seat:*]
session-wrapper=/etc/lightdm/Xsession

[XDMCPServer]
#enabled=false
#port=177
#listen-address=
#key=
#hostname=

[VNCServer]
#enabled=false
#command=Xvnc
#port=5900
#listen-address=
#width=1024
#height=768
#depth=8" | sudo tee /etc/lightdm/lightdm.conf

# PDF Reader
yay -S --noconfirm zathura zathura-pdf-poppler

# Set A4 as default papersize
if [[ ! $updating =~ ^[Yy]$ ]]; then
    echo 'a4' | sudo tee -a /etc/papersize
fi

# Libreoffice, Microsoft Office but for Linux!
yay -S --noconfirm libreoffice-fresh

yay -S --noconfirm dunst

# Fonts take long to install, only needed once
if [[ ! $updating =~ ^[Yy]$ ]]; then
    # Windows fonts
    yay -S --noconfirm ttf-ms-win10-auto
    # Patched fonts for ranger and other stuff
    yay -S --noconfirm nerd-fonts-complete
fi
yay -S --noconfirm wqy-zenhei ttf-jetbrains-mono ttf-hack ttf-font-awesome

# yay -S --noconfirm grub os-prober intel-ucode efibootmgr

## EFI:
# sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

## Boot:
## /dev/sdX is the disk (not partition) where GRUB should be installed
# sudo grub-install --target=i386-pc /dev/sdX

# sudo grub-mkconfig -o /boot/grub/grub.cfg

# Theme
rm -rf $HOME/.themes/Dracula
git clone https://github.com/dracula/gtk $HOME/.themes/Dracula

# File chooser for GTK
gsettings set org.gtk.Settings.FileChooser show-hidden true
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gtk.Settings.FileChooser sort-column 'name'

# yay -S logmein-hamachi haguichi
# echo "Ipc.User flyslime
# Setup.AutoNick FlySlime" | sudo tee -a /var/lib/logmein-hamachi/h2-engine-override.cfg

yay -S --noconfirm i3-gaps feh tldr wmctrl

yay -S --noconfirm python-i3ipc autotiling

yay -S --noconfirm picom

yay -S --noconfirm rofi papirus-icon-theme

yay -S --noconfirm betterlockscreen

cp /usr/share/doc/betterlockscreen/examples/betterlockscreenrc $HOME/.config

# If your Pictures/Wallpapers folder is empty, download a wallpaper
if [ -z "$(ls -A $HOME/Pictures/Wallpapers)" ]; then
    mkdir -p $HOME/Pictures/Wallpapers
    yay -S --noconfirm curl wget
    curl https://images.wallpaperscraft.com/image/deer_art_vector_134088_1920x1080.jpg > $HOME/Pictures/Wallpapers/deer_art_vector_1920x1080.jpg
fi

# Sets lockscreen
betterlockscreen -u $HOME/Pictures/Wallpapers

yay -S --noconfirm polybar lm_sensors gsimplecal inxi
sudo sensors-detect --auto

yay -S --noconfirm kdenlive

yay -S --noconfirm discord_arch_electron

# Pass audio through applications, enables audio for discord screen-sharing
yay -S --noconfirm soundux

# End-to-end messaging app for Android
yay -S --noconfirm signal-desktop

# Fun typing game
yay -S --noconfirm typespeed

# I use arch btw
yay -S --noconfirm neofetch

# Color text with lolcat =w=
yay -S --noconfirm lolcat

# Inspiring quotes for the day
yay -S --noconfirm cowfortune

# yay -S --noconfirm mpd mopidy mopidy-spotify mopidy-mpd ncmpcpp

yay -S --noconfirm networkmanager nm-connection-editor networkmanager-dmenu-git
sudo systemctl enable NetworkManager.service

yay -S --noconfirm onboard

## Nvidia Users
if [[ $nvidia =~ ^[Yy]$ ]]; then
	yay -S --noconfirm nvidia nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
fi

## AMD Users
# not added yet

# --noconfirm turned off for different CPUs
yay -S mesa lib32-mesa

# Optimized kernel
yay -S --noconfirm linux-zen linux-zen-headers

# Refresh grub so it detects the new kernel
if [ -z "$(ls -A /boot/grub)" ]; then
	sudo mkdir /boot/grub
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg

yay -S --noconfirm ranger w3m atool unzip unrar zip

# To show icons in ranger
rm -rf $HOME/.config/ranger/plugins/ranger_devicons
git clone https://github.com/alexanderjeurissen/ranger_devicons $HOME/.config/ranger/plugins/ranger_devicons

# To drag and drop files from Ranger
yay -S --noconfirm dragon-drag-and-drop

yay -S --noconfirm redshift python-gobject

yay -S --noconfirm kitty exa tree

# Theme for kitty
curl -o $HOME/.config/kitty/snazzy.conf https://raw.githubusercontent.com/connorholyday/kitty-snazzy/master/snazzy.conf

# Task manager
yay -S --noconfirm bpytop

# Shell
yay -S --noconfirm zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions
if [[ ! $updating =~ ^[Yy]$ ]]; then
    # Make zsh main shell
	chsh -s /bin/zsh
fi

# Pure install
rm -rf "$HOME/.zsh"
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

# Emacs
yay -S --noconfirm emacs ripgrep fd

# Packages for Doom Emacs modules
yay -S --noconfirm editorconfig-core-c hunspell-en_US hunspell-sv libvterm

# C/C++
yay -S --noconfirm clang cmake

# Emacs Everywhere
yay -S --noconfirm xclip xdotool

# Grammar
yay -S --noconfirm languagetool

# bash
## Formatter
yay -S --noconfirm shfmt

# Python
yay -S --noconfirm python-pip
## LSP
pip install 'python-language-server[all]'
## Formatter
pip install black

# Java
yay -S --noconfirm jdk-openjdk java-openjfx
## LSP
# yay -S --noconfirm jdtls

# # Haskell
# yay -S stack ncurses5-compat-libs ghc haskell-language-server-bin
# stack setup
# ## Install Hoogle (Google but for Haskell!)
# stack install hoogle
# ## Formatter
# stack install brittany
# ## Install QuickCheck
# yay -S haskell-quickcheck

# LaTeX
if [[ ! $updating =~ ^[Yy]$ ]]; then
	yay -S --noconfirm texlive-most biber
fi

# Tools for LaTeX
yay -S --noconfirm ghostscript mathpix-snipping-tool inkscape textext

# Doom Emacs
if [ -z "$(ls -A $HOME/.emacs.d)" ]; then
	git clone --depth 1 https://github.com/hlissner/doom-emacs $HOME/.emacs.d
	$HOME/.emacs.d/bin/doom install
fi

yay -S --noconfirm deluge deluge-gtk

yay -S --noconfirm xorg

if [[ $laptop =~ ^[Yy]$ ]]; then
    yay -S --noconfirm tlp powertop
    sudo systemctl enable tlp.service
fi

if [[ $gaming =~ ^[Yy]$ ]]; then
	# --noconfirm turned off due to GPU driver selection
	yay -S steam
	yay -S --noconfirm gamemode lib32-gamemode
	yay -S --noconfirm protontricks
	yay -S --noconfirm obs-studio
	yay -S --noconfirm lutris
	yay -S --noconfirm wine-staging winetricks
	# make cpu run at perfomance mode
	yay -S --noconfirm cpupower
	echo "cpupower frequency-set -g performance" | sudo tee -a /etc/rc.local
	# fps/cpu/gpu tracker
	yay -S --noconfirm mangohud lib32-mangohud
	# fps limiter
	yay -S --noconfirm libstrangle-git
    if [[ ! $updating =~ ^[Yy]$ ]]; then
        echo "*                hard    nofile          1048576" | sudo tee -a /etc/security/limits.conf
        echo "*                soft    nofile          1048576" | sudo tee -a /etc/security/limits.conf
    fi
fi

$HOME/bin/clearCache; $HOME/bin/clearOrphans
