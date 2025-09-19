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

# Install packages
sudo apt-get DEBIAN_FRONTEND=noninteractive install siege wget curl tcpdump fping nmap -y

echo

echo "Post-install script finished."
