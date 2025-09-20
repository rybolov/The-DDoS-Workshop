@echo off
setlocal

@echo off
vagrant --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Vagrant is installed.
) ELSE (
    echo Vagrant is NOT installed.
    goto end
)

REM Check if VirtualBox is installed
echo Checking for VirtualBox...
VBoxManage --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo VirtualBox is NOT installed or not in PATH.
    goto end
)
echo VirtualBox is installed.

REM Install the vagrant-vbguest plugin
echo Installing vagrant-vbguest plugin...
vagrant plugin install vagrant-vbguest
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to install vagrant-vbguest plugin.
    goto end
)

REM Start the DDoSAttacker VM
echo Starting DDoSAttacker VM...
cd VirtualMachines\DDoSAttacker
vagrant up && vagrant upload AttackScripts /home/vagrant/bin
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to start DDoSAttacker VM.
    goto end
)

REM Start the DDoSTarget VM
echo Starting DDoSTarget VM...
cd ..\DDoSTarget
vagrant up && vagrant upload "../../PCAP-Samples" /home/vagrant/PCAP-Samples
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to start DDoSTarget VM.
    goto end
)

:end
echo Script complete.
pause
