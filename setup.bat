@echo off
setlocal
title Setup Compare Checksum from Clipboard

set "AppDir=%AppData%\Compare Checksum from Clipboard"
set "AppFile=%AppDir%\App.ps1"

if not exist "%AppDir%" mkdir "%AppDir%"
copy app.ps1 "%AppFile%"

reg add "HKCU\Software\Classes\*\shell\CompareChecksumFromClipboard" /ve /d "&Compare Checksum from Clipboard" /f
reg add "HKCU\Software\Classes\*\shell\CompareChecksumFromClipboard\command" /ve /d "cmd /c powershell -NoProfile -ExecutionPolicy Bypass -File \"%AppFile%\" \"%%1\"" /f

echo Done!
pause

endlocal
