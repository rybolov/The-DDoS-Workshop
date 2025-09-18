#!/bin/bash

echo "Starting post-install provisioning for Ubuntu 25.04..."

# Set the root password
echo "root:ddos" | chpasswd

# Change the password for the 'vagrant' user
echo "vagrant:ddos" | chpasswd

# Update the system
sudo apt-get update
sudo apt-get dist-upgrade -y

# Install packages.  This should have wireshark but it was failing for me, so I took it out for now.
sudo apt-get install ubuntu-desktop apache2 nmap -y

# Create a simple index.html file
echo "<h1>Hello from Ubuntu 25.04!</h1>" | sudo tee /var/www/html/index.html

echo "Post-install script finished. Rebooting now."
