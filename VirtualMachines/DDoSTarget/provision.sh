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
sudo DEBIAN_FRONTEND=noninteractive apt -y install apache2 nmap tshark iptraf nload gdm3
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt -y install --no-install-recommends wireshark gnome-terminal ubuntu-desktop-minimal
sudo groupadd wireshark
sudo usermod -a -G wireshark vagrant

# Make this directory writeable so that we can upload content to it.
sudo chmod -R 777 /var/www/html
sudo cp /vagrant/webcontent/*.html /var/www/html/

#Add a job to cron to make normal traffic
# Cron expression
cron="@reboot sudo /home/vagrant/bin/throttle-bandwidth.sh"

# Check if cron job already in crontab
crontab -l | grep "${cron_escaped}"
if [[ $? -eq 0 ]] ;
  then
    echo "Crontab already exists. Exiting..."
    exit
  else
    # Write out current crontab into temp file
    crontab -l > mycron
    # Append new cron into cron file
    echo "$cron" >> mycron
    # Install new cron file
    crontab mycron
    # Remove temp file
    rm mycron
fi


echo "192.168.56.3 attacker" | sudo tee -a /etc/hosts

/etc/init.d/gdm3 restart


echo "Post-install script finished."