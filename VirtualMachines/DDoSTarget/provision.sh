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
sudo DEBIAN_FRONTEND=noninteractive apt install gdm3 ubuntu-desktop apache2 nmap wireshark -y

# Create a simple index.html file
echo "<h1>Hello from Ubuntu 25.04!</h1>" | sudo tee /var/www/html/index.html

/etc/init.d/gdm3 restart

echo "Post-install script finished."
