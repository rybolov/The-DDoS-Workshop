#!/bin/bash

echo "Starting post-install provisioning for Ubuntu 25.04..."


# Set the root password
echo "root:ddos" | chpasswd

# Change the password for the 'vagrant' user
echo "vagrant:ddos" | chpasswd


# Update the system packages
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt autoremove

# Install packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install siege wget curl tcpdump fping nmap slowloris hping3

# Set up a ton of IP addresses on virtual interfaces
echo "---
network:
  version: 2
  renderer: networkd
  ethernets:
    eth1:
      addresses:
      - 192.168.56.3/24" | sudo tee /etc/netplan/50-vagrant.yaml
for i in {4..254}; do
  echo "      - 192.168.56.$i/24" | sudo tee -a /etc/netplan/50-vagrant.yaml
done
sudo netplan apply

echo "192.168.56.2 target" | sudo tee -a /etc/hosts

#Add a job to cron to make normal traffic
# Cron expression
cron="* * * * * /bin/bash /home/vagrant/bin/traffic-normal-simulated.sh"
    # │ │ │ │ │
    # │ │ │ │ │
    # │ │ │ │ └───── day of week (0 - 6) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
    # │ │ │ └────────── month (1 - 12)
    # │ │ └─────────────── day of month (1 - 31)
    # │ └──────────────────── hour (0 - 23)
    # └───────────────────────── min (0 - 59)

# Escape all the asterisks so we can grep for it
cron_escaped=$(echo "$cron" | sed s/\*/\\\\*/g)

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



echo "Post-install script finished."