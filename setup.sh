#!/bin/bash
set -e

current_dir=$(pwd)
LOGFILE="../install.log"
INSTALL_STATUS="SUCCESS"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

log "==== Installation Started ===="

# System Info
log "Collecting system information..."
{
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo "OS: $(uname -s) $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "Uptime: $(uptime -p)"
    echo "Memory: $(free -h | grep Mem)"
    echo "Disk Usage: $(df -h / | tail -1)"
} >> "$LOGFILE"

# Check if Vagrant is installed
log "Checking for Vagrant..."
if ! command -v vagrant &> /dev/null; then
    log "Vagrant is NOT installed."
    INSTALL_STATUS="FAILED"
    echo "Installation Status: $INSTALL_STATUS"
    exit 1
fi
log "Vagrant is installed."

# Check if VirtualBox is installed
log "Checking for VirtualBox..."
if ! command -v VBoxManage &> /dev/null; then
    log "VirtualBox is NOT installed or not in PATH."
    INSTALL_STATUS="FAILED"
    echo "Installation Status: $INSTALL_STATUS"
    exit 1
fi
log "VirtualBox is installed."

# Install the vagrant-vbguest plugin
log "Installing vagrant-vbguest plugin..."
if vagrant plugin install vagrant-vbguest 2>&1 | tee -a "$LOGFILE" ; then
    log "vagrant-vbguest plugin installed successfully."
else
    log "Failed to install vagrant-vbguest plugin."
    INSTALL_STATUS="FAILED"
    echo "Installation Status: $INSTALL_STATUS"
    exit 1
fi

# Check and start DDoSAttacker VM
log "Checking status of DDoSAttacker VM..."
cd "$current_dir/VirtualMachines/DDoSAttacker" || { log "Directory not found: DDoSAttacker"; INSTALL_STATUS="FAILED"; echo "Installation Status: $INSTALL_STATUS"; exit 1; }
VM_STATUS=$(vagrant status --machine-readable | grep ",state," | cut -d',' -f4)
log "DDoSAttacker VM status: $VM_STATUS"
if [ "$VM_STATUS" != "running" ]; then
    log "Starting DDoSAttacker VM..."
    if ( (vagrant up 2>&1 | tee -a "$LOGFILE") && (vagrant upload AttackScripts /home/vagrant/bin 2>&1 | tee -a "$LOGFILE"); ) then
        log "DDoSAttacker VM started successfully."
    else
        log "Failed to start DDoSAttacker VM."
        INSTALL_STATUS="FAILED"
        echo "Installation Status: $INSTALL_STATUS"
        exit 1
    fi
else
    log "DDoSAttacker VM is already running."
fi

# Check and start DDoSTarget VM
log "Checking status of DDoSTarget VM..."
cd "$current_dir/VirtualMachines/DDoSTarget" || { log "Directory not found: DDoSTarget"; INSTALL_STATUS="FAILED"; echo "Installation Status: $INSTALL_STATUS"; exit 1; }
VM_STATUS=$(vagrant status --machine-readable | grep ",state," | cut -d',' -f4)
log "DDoSTarget VM status: $VM_STATUS"
if [ "$VM_STATUS" != "running" ]; then
    log "Starting DDoSTarget VM..."
    if ( vagrant up 2>&1 | tee -a "$LOGFILE"; ) then
        log "DDoSTarget VM started successfully."
    else
        log "Failed to start DDoSTarget VM."
        INSTALL_STATUS="FAILED"
        echo "Installation Status: $INSTALL_STATUS"
        exit 1
    fi
else
    log "DDoSTarget VM is already running."
fi

# Uploading PCAP Samples to DDoSTarget VM
# These go into /home/vagrant/PCAP-Samples
cd "$current_dir/VirtualMachines/DDoSTarget" || { log "Directory not found: DDoSTarget"; INSTALL_STATUS="FAILED"; echo "Installation Status: $INSTALL_STATUS"; exit 1; }
if ( (vagrant upload "$current_dir/PCAP-Samples" /home/vagrant/PCAP-Samples 2>&1 | tee -a "$LOGFILE") && (vagrant upload "$current_dir/VirtualMachines/DDoSTarget/web/html" /home/vagrant/PCAP-Samples 2>&1 | tee -a "$LOGFILE"); ) then
  log "DDoSTarget uploaded PCAP samples successfully."
else
  log "Failed upload PCAP Samples."
  INSTALL_STATUS="FAILED"
  echo "Installation Status: $INSTALL_STATUS"
  exit 1
fi

# Uploading web content to DDoSTarget VM
# These go into /var/www/html
cd "$current_dir/VirtualMachines/DDoSTarget" || { log "Directory not found: DDoSTarget"; INSTALL_STATUS="FAILED"; echo "Installation Status: $INSTALL_STATUS"; exit 1; }
if ( (vagrant upload "$current_dir/VirtualMachines/DDoSTarget/webcontent" /var/www/html/ 2>&1 | tee -a "$LOGFILE"); ) then
  log "DDoSTarget uploaded web content successfully."
else
  log "Failed upload web content."
  INSTALL_STATUS="FAILED"
  echo "Installation Status: $INSTALL_STATUS"
  exit 1
fi

# Bandwidth limit the DDoS Target
# Establish the speed limit as a group: VBoxManage bandwidthctl "DDoS Target" add NetLimit --type network --limit
# Apply the limit to the second ethernet adapter: VBoxManage modifyvm "DDoS Target" --nicbandwidthgroup2 NetLimit
cd "$current_dir/VirtualMachines/DDoSTarget" || { log "Directory not found: DDoSTarget"; INSTALL_STATUS="FAILED"; echo "Installation Status: $INSTALL_STATUS"; exit 1; }
if ( (vagrant halt 2>&1 | tee -a "$LOGFILE") && (VBoxManage bandwidthctl "DDoS Target" add NetLimit --type network --limit 10m 2>&1 | tee -a "$LOGFILE") && (VBoxManage modifyvm "DDoS Target" --nicbandwidthgroup2 NetLimit 2>&1 | tee -a "$LOGFILE") && (vagrant up 2>&1 | tee -a "$LOGFILE"); ) then
  log "DDoSTarget limited host-only ethernet adapter successfully."
else
  log "Failed to set limit on DDoSTarget ethernet adapter."
  INSTALL_STATUS="FAILED"
  echo "Installation Status: $INSTALL_STATUS"
  exit 1
fi

log "==== Installation Complete ===="
echo "Installation Status: $INSTALL_STATUS"