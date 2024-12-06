@echo off
setlocal
set AutoItCompiler="%programfiles%\AutoIt3\Aut2Exe\Aut2Exe.exe"
if not exist %AutoItCompiler% (
 set AutoItCompiler="%programfiles(x86)%\AutoIt3\Aut2Exe\Aut2Exe.exe"
)

title Building...
if not exist dist mkdir dist

%AutoItCompiler% /in src\app.au3 /out dist\CCfC.exe

%AutoItCompiler% /in src\uninstaller.au3 /out dist\Uninstaller.exe

%AutoItCompiler% /in src\installer.au3 /out "dist\Compare Checksum from Clipboard Setup.exe"

if exist "dist\Compare Checksum from Clipboard Setup.exe" (
 del dist\CCfC.exe
 del dist\Uninstaller.exe

 powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('The compiled setup program is located in the dist folder.', 'Build Complete', 'Ok', 'Information')"
) else (
 powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Failed to compile the program.', 'Build Fail', 'Ok', 'Information')"
)

endlocal
