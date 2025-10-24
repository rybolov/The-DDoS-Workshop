@echo off
setlocal
set "current_dir=%~dp0"
set "LOGFILE=%current_dir%\install.log"
set "INSTALL_STATUS=SUCCESS"

REM Entry point
call :checkVagrant
call :checkVirtualBox
call :installPlugin
call :setupAttacker
call :setupTarget
call :limitBandwidth

goto :end

REM ────────────────────────────────────────────────
:checkVagrant
vagrant --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    call :log "Vagrant is installed."
) ELSE (
    call :log "Vagrant is NOT installed."
    set INSTALL_STATUS=FAILED
    goto :end
)
goto :eof

REM ────────────────────────────────────────────────
:checkVirtualBox
VBoxManage --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    call :log "VirtualBox is installed."
) ELSE (
    call :log "VirtualBox is NOT installed or not in PATH."
    set INSTALL_STATUS=FAILED
    goto :end
)
goto :eof

REM ────────────────────────────────────────────────
:installPlugin
call :log "Installing vagrant-vbguest plugin..."
vagrant plugin install vagrant-vbguest >> "%LOGFILE%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    call :log "Failed to install vagrant-vbguest plugin."
    set INSTALL_STATUS=FAILED
    goto :end
)
goto :eof

REM ────────────────────────────────────────────────
:setupAttacker
call :log "Starting DDoSAttacker VM..."
cd "%current_dir%\VirtualMachines\DDoSAttacker"
vagrant up >> "%LOGFILE%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    call :log "Failed to start DDoSAttacker VM."
    set INSTALL_STATUS=FAILED
    goto :end
)

vagrant upload AttackScripts /home/vagrant/bin >> "%LOGFILE%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    call :log "Failed to upload AttackScripts to DDoSAttacker."
    set INSTALL_STATUS=FAILED
    goto :end
) ELSE (
    call :log "DDoSAttacker uploaded AttackScripts successfully."
)
goto :eof

REM ────────────────────────────────────────────────
:setupTarget
call :log "Starting DDoSTarget VM..."
cd "%current_dir%\VirtualMachines\DDoSTarget"
vagrant up >> "%LOGFILE%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    call :log "Failed to start DDoSTarget VM."
    set INSTALL_STATUS=FAILED
    goto :end
)

vagrant upload "%current_dir%\PCAP-Samples" /home/vagrant/PCAP-Samples >> "%LOGFILE%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    call :log "Failed to upload PCAP-Samples to DDoSTarget."
    set INSTALL_STATUS=FAILED
    goto :end
) ELSE (
    call :log "DDoSTarget uploaded PCAP samples successfully."
)

vagrant upload webcontent /var/www/html >> "%LOGFILE%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    call :log "Failed to upload web content to DDoSTarget."
    set INSTALL_STATUS=FAILED
    goto :end
) ELSE (
    call :log "DDoSTarget uploaded web content successfully."
)

vagrant upload TargetScripts /home/vagrant/bin >> "%LOGFILE%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    call :log "Failed to upload TargetScripts to DDoSTarget."
    set INSTALL_STATUS=FAILED
    goto :end
) ELSE (
    call :log "DDoSTarget uploaded TargetScripts successfully."
)
goto :eof

@REM     REM ────────────────────────────────────────────────
@REM     :limitBandwidth
@REM     call :log "Applying bandwidth limit to DDoSTarget..."
@REM     vagrant halt >> "%LOGFILE%" 2>&1
@REM     IF %ERRORLEVEL% NEQ 0 (
@REM         call :log "Failed to halt DDoSTarget."
@REM         set INSTALL_STATUS=FAILED
@REM         goto :end
@REM     )

@REM     VBoxManage bandwidthctl "DDoS Target" add NetLimit --type network --limit 20m >> "%LOGFILE%" 2>&1
@REM     IF %ERRORLEVEL% NEQ 0 (
@REM         call :log "Failed to set bandwidth limit."
@REM         set INSTALL_STATUS=FAILED
@REM         goto :end
@REM     )

@REM     VBoxManage modifyvm "DDoS Target" --nicbandwidthgroup2 NetLimit >> "%LOGFILE%" 2>&1
@REM     IF %ERRORLEVEL% NEQ 0 (
@REM         call :log "Failed to apply bandwidth group to NIC."
@REM         set INSTALL_STATUS=FAILED
@REM         goto :end
@REM     )

@REM     vagrant up >> "%LOGFILE%" 2>&1
@REM     IF %ERRORLEVEL% NEQ 0 (
@REM         call :log "Failed to restart DDoSTarget after bandwidth limit."
@REM         set INSTALL_STATUS=FAILED
@REM         goto :end
@REM     ) ELSE (
@REM         call :log "DDoSTarget limited host-only ethernet adapter successfully."
@REM     )
@REM # goto :eof

REM ────────────────────────────────────────────────
:log
set "timestamp=%DATE% %TIME%"
echo [%timestamp%] %~1 >> "%LOGFILE%"
echo [%timestamp%] %~1
goto :eof

REM ────────────────────────────────────────────────
:end
echo Installation Status: %INSTALL_STATUS%
echo Script complete.
pause