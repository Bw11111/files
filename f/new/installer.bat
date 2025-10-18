@echo off
setlocal
set "CurrentDir=%~dp0"
set "ExePath=%CurrentDir%wifimonitor.exe"
echo Creating service...
sc create WifiMonitorService binPath= "%ExePath%"
echo Starting service...
sc start WifiMonitorService
pause
