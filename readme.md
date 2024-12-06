# Compare Checksum from Clipboard

This is a small script for Windows that adds an entry to the File Explorer context menu to compare a checksum from the clipboard against the file hash of any file on the computer. It supports MD5, SHA-1, SHA-256, SHA-384, and SHA-512.

## Installation

Simply run Setup.bat from this project.

## Usage

1. Copy a checksum into the clipboard.
2. Open File Explorer and locate the file you want to compare the checksum against.
3. Right-click the file and choose "Compare Checksum from Clipboard" in the context menu.
4. The program will automatically figure out which of the supported algorithms to use, then it calculates the hash of the file before it compares the result with the checksum from the clipboard and produces a message box indicating success or failure.
