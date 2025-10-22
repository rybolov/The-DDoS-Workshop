#!/bin/bash
# Upload the scripts to each of the virtual machines. I used this for development and it's not needed normally.

current_dir=$(pwd)
(cd $current_dir/VirtualMachines/DDoSAttacker/ && vagrant upload AttackScripts /home/vagrant/bin)
(cd $current_dir/VirtualMachines/DDoSTarget && vagrant upload TargetScripts /home/vagrant/bin)
(cd $current_dir/VirtualMachines/DDoSTarget && vagrant upload webcontent /var/www/html)
(cd $current_dir/VirtualMachines/DDoSTarget && vagrant upload "$current_dir/PCAP-Samples" /home/vagrant/PCAP-Samples)