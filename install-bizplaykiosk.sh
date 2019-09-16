#!/bin/bash

# update ubuntu
sudo apt-get update && apt-get upgrade -y

# get software
sudo apt-get install \
  unclutter \
  chromium \
  ssh \
  -y

# Change Default sound card
# load-module module-stream-restore restore_device=false

# Dir
sudo mkdir -p /home/kiosk/.config/autostart

# create kiosk autostart desktop
if [ -e "/home/kiosk/.config/autostart/kiosk.desktop" ]; then
  mv /home/kiosk/.config/autostart/kiosk.desktop /home/kiosk/.config/autostart/kiosk.desktop.backup
fi
cat > /home/kiosk/.config/autostart/kiosk.desktop << EOF
[Desktop Entry]
Type=Application
Name=chromium
Exec=chromium-browser --password-store=basic --no-first-run --disable --disable-translate --disable-infobars --disable-suggestions-service --disable-save-password-bubble --disable-features=InfiniteSessionRestore --start-maximized --kiosk "http://play.playr.biz"
X-GNOME-Autostart-enabled=true

EOF

echo "Done!"
