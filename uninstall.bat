@echo off
setlocal
title Uninstall Compare Checksum from Clipboard

set "AppDir=%AppData%\Compare Checksum from Clipboard"
set "AppFile=%AppDir%\App.ps1"

if exist "%AppFile%" del "%AppFile%"
if exist "%AppDir%\match.mp3" del "%AppDir%\match.mp3"
if exist "%AppDir%\mismatch.mp3" del "%AppDir%\mismatch.mp3"
if exist "%AppDir%" rmdir "%AppDir%"

reg delete "HKCU\Software\Classes\*\shell\CompareChecksumFromClipboard" /f >nul

echo Done!
pause

endlocal
