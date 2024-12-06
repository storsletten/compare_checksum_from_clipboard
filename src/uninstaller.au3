#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Martin Storsletten

 Script Function:
  Uninstaller for Compare Checksum from Clipboard.

#ce ----------------------------------------------------------------------------


#pragma compile(ProductName, Uninstaller for Compare Checksum from Clipboard)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0.0)
#pragma compile(LegalCopyright, © Martin Storsletten)

#RequireAdmin
#NoTrayIcon

#include "constants.au3"
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>


If Not IsAdmin() Then
 MsgBox($MB_ICONERROR, "Error!", "Uninstallation of " & $appTitle & " requires administrator privileges.")
 Exit
EndIf

If MsgBox(BitOR($MB_ICONQUESTION, $MB_YESNO), "Uninstall " & $appTitle, "Are you sure you wish to uninstall " & $appTitle & "?") <> $IDYES Then
 Exit
EndIf

RegDelete("HKEY_CLASSES_ROOT\*\shell\CompareChecksumFromClipboard")
If @error Then
 MsgBox($MB_ICONERROR, "Error!", "Couldn't remove registry keys pertaining to " & $appTitle & ".")
 Exit
EndIf

Run(@ComSpec & " /c " & '"timeout /t 1 && cd "' & @ScriptDir & _
 '" && del CCfC.exe && del "' & @ScriptName & _
 '" && cd .. && rmdir "' & @ScriptDir & _
 '" && powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show(' & _
 "'" & StringReplace(StringReplace($appTitle, "'", ""), '"', "") & " has been uninstalled.', 'Done!', 'Ok', 'Information'" & _
 ')""', "", @SW_HIDE)
