#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Martin Storsletten

 Script Function:
  Installer for Compare Checksum from Clipboard.

#ce ----------------------------------------------------------------------------


#pragma compile(ProductName, Installer for Compare Checksum from Clipboard)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0.0)
#pragma compile(LegalCopyright, © Martin Storsletten)

#RequireAdmin
#NoTrayIcon

#include "constants.au3"
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>


If Not IsAdmin() Then
 MsgBox($MB_ICONERROR, "Error!", "Installation of " & $appTitle & " cannot proceed without administrator privileges.")
 Exit
EndIf

If MsgBox(BitOR($MB_ICONQUESTION, $MB_YESNO), "Setup " & $appTitle, "Ready to install " & $appTitle & "?") <> $IDYES Then
 Exit
EndIf

DirCreate($appDir)

If Not FileInstall("..\dist\CCfC.exe", $appFile, $FC_OVERWRITE) Then
 MsgBox($MB_ICONERROR, "Error!", "Couldn't install file: " & $appFile)
 Exit
EndIf

If Not FileInstall("..\dist\Uninstaller.exe", $appDir & "\Uninstal.exe", $FC_OVERWRITE) Then
 MsgBox($MB_ICONERROR, "Error!", "Couldn't create the uninstaller for " & $appTitle & ".")
 Exit
EndIf

If RegWrite("HKEY_CLASSES_ROOT\*\shell\CompareChecksumFromClipboard", "", "REG_SZ", "&Compare Checksum from Clipboard") _
And RegWrite("HKEY_CLASSES_ROOT\*\shell\CompareChecksumFromClipboard\command", "", "REG_SZ", '"' & $appFile & '" "%1"') Then
 MsgBox($MB_ICONINFORMATION, "Done!", "The installation of " & $appTitle & " is complete.")
Else
 MsgBox($MB_ICONERROR, "Error!", "Couldn't write registry keys for " & $appTitle & ".")
 Exit
EndIf
