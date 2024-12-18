# Compare Checksum from Clipboard
# Copyright (C) 2024  Martin Storsletten

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName PresentationFramework

$host.UI.RawUI.WindowTitle = "Compare Checksum from Clipboard"

$clipboardContent = [Windows.Clipboard]::GetText()

if ([string]::IsNullOrWhiteSpace($clipboardContent)) {
 [System.Windows.MessageBox]::Show(
  "The clipboard is empty.",
  "Empty Clipboard",
  [System.Windows.MessageBoxButton]::OK,
  [System.Windows.MessageBoxImage]::Warning
 )
 exit
}

$clipboardMatch = [Regex]::Match($clipboardContent, "\b[0-9a-fA-F]{16,}\b")

if ($clipboardMatch.Success -eq $true) {
 $hash = $clipboardMatch.Value
} else {
 [System.Windows.MessageBox]::Show(
  "No valid string of hexadecimals was found in the clipboard.",
  "Missing Checksum",
  [System.Windows.MessageBoxButton]::OK,
  [System.Windows.MessageBoxImage]::Warning
 )
 exit
}

if ($hash.Length -eq 32) {
 $hashType = "MD5"
} elseif ($hash.Length -eq 40) {
 $hashType = "SHA1"
} elseif ($hash.Length -eq 64) {
 $hashType = "SHA256"
} elseif ($hash.Length -eq 96) {
 $hashType = "SHA384"
} elseif ($hash.Length -eq 128) {
 $hashType = "SHA512"
} elseif ($hash.Length % 2 -ne 0) {
 [System.Windows.MessageBox]::Show(
  "The checksum from the clipboard contains $($hash.Length) hexadecimals, but a valid checksum must always have an even number of hexadecimals.",
  "Invalid Checksum",
  [System.Windows.MessageBoxButton]::OK,
  [System.Windows.MessageBoxImage]::Warning
 )
 exit
} else {
 [System.Windows.MessageBox]::Show(
  "The checksum from the clipboard contains $($hash.Length) hexadecimals, which does not correspond with any of the supported algorithms (MD5, SHA1, SHA256, SHA384, or SHA512).",
  "Invalid Checksum",
  [System.Windows.MessageBoxButton]::OK,
  [System.Windows.MessageBoxImage]::Warning
 )
 exit
}

$host.UI.RawUI.WindowTitle = "Compare $($hashType) Checksum from Clipboard"

if ($args.Count -lt 1) {
 $fileDialog = New-Object Microsoft.Win32.OpenFileDialog
 $fileDialog.InitialDirectory = "$env:USERPROFILE\Downloads"
 $dialogResult = $fileDialog.ShowDialog()
 if (-not $dialogResult) {
  exit
 }
 $filePath = $fileDialog.FileName
} else {
 $filePath = $args[0]
}

if (-not (Test-Path $filePath)) {
 [System.Windows.MessageBox]::Show(
  "The file does not exist: $filePath",
  "Missing File",
  [System.Windows.MessageBoxButton]::OK,
  [System.Windows.MessageBoxImage]::Warning
 )
 exit
}

$fileSize = (Get-Item -LiteralPath $filePath).Length
if ($fileSize -gt 250MB) {
 $fileSizeMB = [Math]::Round($fileSize / 1MB, 2)
 Write-Host "Warning: The file size is $fileSizeMB MB, which means it might take a while to finish calculating its checksum."
}

try {
 $calculatedHash = (Get-FileHash -LiteralPath $filePath -Algorithm $hashType).Hash
} catch {
 [System.Windows.MessageBox]::Show(
  "Failed to calculate $hashType checksum of the file. $($_.Exception.Message)",
  "Error!",
  [System.Windows.MessageBoxButton]::OK,
  [System.Windows.MessageBoxImage]::Error
 )
 exit
}

if ($calculatedHash -ieq $hash) {
 [System.Windows.MessageBox]::Show(
  "The $hashType checksum from the clipboard matched the file hash.",
  "Success!",
  [System.Windows.MessageBoxButton]::OK,
  [System.Windows.MessageBoxImage]::Information
 )
} else {
 [System.Windows.MessageBox]::Show(
  "The $hashType checksum from the clipboard did not match the file hash.",
  "Failed Match",
  [System.Windows.MessageBoxButton]::OK,
  [System.Windows.MessageBoxImage]::Warning
 )
}
