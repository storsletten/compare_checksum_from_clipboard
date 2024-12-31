@echo off
setlocal
title Setup Compare Checksum from Clipboard

set "AppDir=%AppData%\Compare Checksum from Clipboard"
set "AppFile=%AppDir%\app.ps1"

if not exist "%AppDir%" mkdir "%AppDir%"
copy match.mp3 "%AppDir%" >nul
copy mismatch.mp3 "%AppDir%" >nul
copy app.ps1 "%AppDir%" >nul

reg add "HKCU\Software\Classes\*\shell\CompareChecksumFromClipboard" /ve /d "&Compare Checksum from Clipboard" /f >nul
reg add "HKCU\Software\Classes\*\shell\CompareChecksumFromClipboard\command" /ve /d "cmd /c powershell -NoProfile -ExecutionPolicy Bypass -File \"%AppFile%\" \"%%1\"" /f >nul

echo Done!
pause

endlocal
