#!/bin/bash

# Add non-free source list
if [ -e "/etc/apt/sources.list" ]; then
  cp /etc/apt/sources.list /etc/apt/sources.list.backup
fi
cat > /etc/apt/sources.list << EOF
# deb cdrom:[Debian GNU/Linux 10.0.0 _Buster_ - Official amd64 NETINST 20190706-10:23]/ buster main
# deb cdrom:[Debian GNU/Linux 10.0.0 _Buster_ - Official amd64 NETINST 20190706-10:23]/ buster main
deb http://deb.debian.org/debian/ buster main
deb-src http://deb.debian.org/debian/ buster main
deb http://security.debian.org/debian-security buster/updates main
deb-src http://security.debian.org/debian-security buster/updates main
# buster-updates, previously known as 'volatile'
deb http://deb.debian.org/debian/ buster-updates main
deb-src http://deb.debian.org/debian/ buster-updates main
# non-free drivers
deb http://httpredir.debian.org/debian/ buster main contrib non-free
EOF

# Regenarate Source list
apt-get update && apt-get upgrade

# Install non-free drivers
apt-get install firmware-realtek firmware-misc-nonfree -y

# Install component
apt-get install xorg lxde-core tightvncserver chromium unclutter xrdp vlc ttf-mscorefonts-installer sudo  -y

# Config lightdm
if [ -e "/etc/lightdm/lightdm.conf" ]; then
  cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.backup
fi
cat > /etc/lightdm/lightdm.conf << EOF
[SeatDefaults]
autologin-user=kiosk
autologin-user-timeout=0
[VNCServer]
enabled=true
command=Xvnc
enabled=true
port=5900
EOF

# Autostart
if [ -e "/etc/xdg/lxsession/LXDE/autostart" ]; then
  cp /etc/xdg/lxsession/LXDE/autostart /etc/xdg/lxsession/LXDE/autostart.backup
fi
cat > /etc/xdg/lxsession/LXDE/autostart << EOF
@lxpanel --profile LXDE
@pcmanfm --desktop --profile LXDE
# @xscreensaver -no-splash
@chromium --kiosk http://play.playr.biz
@xset -display :0 s off -dpms
EOF

# Desactivation du powersaving
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Create Kiosk user
# sudo useradd kiosk

# Chromium Preferences
if [ -e "./.config/chromium/Default/Preferences" ]; then
  cp ./.config/chromium/Default/Preferences ./.config/chromium/Default/Preferences.backup
fi
sed -i 's/"site_engagement":{}/"site_engagement":{"http://play.playr.biz:80,*"}/' ./.config/chromium/Default/Preferences
sed -i 's/"sound":{}/"sound":{play.playr.biz,*}/' ./.config/chromium/Default/Preferences

echo "Done!"
