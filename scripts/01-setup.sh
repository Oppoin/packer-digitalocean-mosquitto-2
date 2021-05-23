#!/bin/bash

# Add a swap file to prevent build time OOM errors
fallocate -l 4G /swapfile
mkswap /swapfile
swapon /swapfile

# install software
apt-add-repository ppa:mosquitto-dev/mosquitto-ppa -y
apt -qqy update
apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' full-upgrade
# mosquitto packages
apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install mosquitto mosquitto-clients


apt -qqy clean
apt -qqy autoremove

chmod +x /var/lib/cloud/scripts/per-instance/001_onboot
# Enable your image specific various software bash scripts
# Note that these bash scripts are under `files/usr/local/bin` usually
# chmod +x /usr/local/bin/{{ your-software }}-update.sh

ufw limit ssh
# your image-specific ufw rules here. Ideally the tighter overall the better. Such as
ufw allow https
ufw allow http
ufw --force enable

# Disable and remove the swapfile prior to snapshotting
swapoff /swapfile
rm -f /swapfile

rm -f /var/log/auth.log
rm -f /var/log/kern.log
rm -f /var/log/ufw.log
