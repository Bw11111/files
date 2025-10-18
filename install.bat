@echo off
setlocal

:: Get the directory this batch file is running from
set "CurrentDir=%~dp0"

:: Build full path to the EXE
set "ExePath=%CurrentDir%shitshat.exe"

:: Create the service
echo Creating service...
sc create WifiMonitorService binPath= "%ExePath%"

:: Start the service
echo Starting service...
sc start WifiMonitorService

pause
