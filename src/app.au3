#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Martin Storsletten

 Script Function:
  Compares a checksum from the clipboard against any file.
  Supported checksums: MD5, SHA-1, SHA-256, SHA-384, and SHA-512.

#ce ----------------------------------------------------------------------------


#pragma compile(ProductName, Compare Checksum from Clipboard)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0.0)
#pragma compile(LegalCopyright, © Martin Storsletten)

#NoTrayIcon

#include "constants.au3"
#include <Crypt.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>

Global $algorithm = 0
Global $algorithmName = ""
Global $filePath = ""
Global $hash = ""
Global $hashLen = 0

If $CmdLine[0] Then
 $filePath = $CmdLine[1]
Else
 $filePath = FileOpenDialog("Choose a File for Comparing Checksum", "", "All files (*.*)", $FD_FILEMUSTEXIST)
 If @error Then
  Exit
 EndIf
EndIf

If Not FileExists($filePath) Then
 MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "File does not exist: " & $filePath)
 Exit
EndIf

$hash = ClipGet()

Switch @error
 Case 0
  $hash = StringUpper(StringStripWS($hash, $STR_STRIPALL))
 Case 1
  $hash = ""
 Case 2
  MsgBox(BitOR($MB_ICONWARNING, $MB_SYSTEMMODAL), "Non-text Content in the Clipboard", "Only regular text content from the clipboard is supported.")
  Exit
 Case 3
  MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Clipboard Unavailable", "This program cannot access the clipboard.")
  Exit
 Case 4
  MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Clipboard Unavailable", "This program cannot access the clipboard.")
  Exit
EndSwitch

If $hash = "" Then
 MsgBox(BitOR($MB_ICONWARNING, $MB_SYSTEMMODAL), "Empty Clipboard", "There is nothing in the clipboard.")
 Exit
ElseIf Not StringIsXDigit($hash) Then
 MsgBox(BitOR($MB_ICONWARNING, $MB_SYSTEMMODAL), "Invalid Format", "The text in the clipboard must be a string of hexadecimals.")
 Exit
EndIf

$hashLen = StringLen($hash)

Switch $hashLen
 Case 32
  $algorithm = $CALG_MD5
  $algorithmName = "MD5"
 Case 40
  $algorithm = $CALG_SHA1
  $algorithmName = "SHA-1"
 Case 64
  $algorithm = $CALG_SHA_256
  $algorithmName = "SHA-256"
 Case 96
  $algorithm = $CALG_SHA_384
  $algorithmName = "SHA-384"
 Case 128
  $algorithm = $CALG_SHA_512
  $algorithmName = "SHA-512"
 Case Else
  If Mod($hashLen, 2) Then
   MsgBox(BitOR($MB_ICONWARNING, $MB_SYSTEMMODAL), "Odd Checksum Length", "The clipboard contains " & $hashLen & " hexadecimal" & (($hashLen = 1) ? "" : "s") & ", but a valid checksum must have an even number of hexadecimals.")
  Else
   MsgBox(BitOR($MB_ICONWARNING, $MB_SYSTEMMODAL), "Invalid Checksum Length", "The clipboard contains " & $hashLen & " hexadecimal" & (($hashLen = 1) ? "" : "s") & ", which doesn't correspond to any of the supported algorithms (MD5, SHA-1, SHA-256, SHA-384, or SHA-512).")
  EndIf
  Exit
EndSwitch

_Crypt_Startup()
$fileHash = _Crypt_HashFile($filePath, $algorithm)
$fileHashError = @error
_Crypt_Shutdown()

If $fileHashError Then
 MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), "Error!", "Couldn't calculate the " & $algorithmName & " checksum of file:" & @CRLF & $filePath)
 Exit
EndIf

$fileHash = StringUpper(StringTrimLeft($fileHash, 2))

If $hash = $fileHash Then
 MsgBox(BitOR($MB_ICONINFORMATION, $MB_SYSTEMMODAL), "Success!", "The " & $algorithmName & " checksum from the clipboard matched with the file hash.")
Else
 MsgBox(BitOR($MB_ICONWARNING, $MB_SYSTEMMODAL), "Failed!", "The " & $algorithmName & " checksum from the clipboard did not match with the file hash:" & @CRLF & $fileHash)
EndIf
