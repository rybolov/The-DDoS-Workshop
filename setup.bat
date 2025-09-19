@echo off
setlocal

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
vagrant up
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to start DDoSAttacker VM.
    goto end
)

REM Start the DDoSTarget VM
echo Starting DDoSTarget VM...
cd ..\DDoSTarget
vagrant up
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to start DDoSTarget VM.
    goto end
)

:end
echo Script complete.
pause
