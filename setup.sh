#!/bin/bash
set -e

# Check if Vagrant is installed
echo "Checking for Vagrant..."
if ! command -v vagrant &> /dev/null; then
    echo "Vagrant is NOT installed."
    exit 1
fi
echo "Vagrant is installed."

# Check if VirtualBox is installed
echo "Checking for VirtualBox..."
if ! command -v VBoxManage &> /dev/null; then
    echo "VirtualBox is NOT installed or not in PATH."
    exit 1
fi
echo "VirtualBox is installed."

# Install the vagrant-vbguest plugin
echo "Installing vagrant-vbguest plugin..."
if ! vagrant plugin install vagrant-vbguest; then
    echo "Failed to install vagrant-vbguest plugin."
    exit 1
fi

# Start the DDoSAttacker VM
echo "Starting DDoSAttacker VM..."
if ! (cd VirtualMachines/DDoSAttacker && vagrant up) ; then
    echo "Failed to start DDoSAttacker VM."
    exit 1
fi

echo "Starting DDoSTarget VM..."
if ! (cd VirtualMachines/DDoSTarget && vagrant up) ; then
    echo "Failed to start DDoSTarget VM."
    exit 1
fi

echo "Script complete."