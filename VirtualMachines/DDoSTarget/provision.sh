#!/bin/bash

echo "Starting post-install provisioning for Ubuntu 25.04..."

# Set the root password
echo "root:ddos" | chpasswd

# Change the password for the 'vagrant' user
echo "vagrant:ddos" | chpasswd

# Update the system
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt autoremove

# Install packages.
sudo DEBIAN_FRONTEND=noninteractive apt -y install apache2 nmap tshark iptraf gdm3
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt -y install --no-install-recommends wireshark gnome-terminal ubuntu-desktop-minimal
sudo usermod -a -G wireshark vagrant

# Make this directory writeable so that we can upload content to it.
sudo chmod -R 777 /var/www/html

/etc/init.d/gdm3 restart

echo "Post-install script finished."