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
sudo DEBIAN_FRONTEND=noninteractive apt-get install siege wget curl tcpdump fping nmap -y

sudo echo "---
network:
  version: 2
  renderer: networkd
  ethernets:
    eth1:
      addresses:
      - 192.168.56.3/24"> /etc/netplan/50-vagrant.yaml
for i in {4..254}; do
  echo "      - 192.168.56.$i/24" >> /etc/netplan/50-vagrant.yaml
done
sudo netplan apply

echo "#!/bin/bash
siege -c50 -t 120S -u http://192.168.56.2/" > /bin/ddos-siege-2min


echo "Post-install script finished."
