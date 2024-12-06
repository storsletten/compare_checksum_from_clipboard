# Compare Checksum from Clipboard

This is a tiny program for Windows that adds an entry to the File Explorer context menu for conveniently comparing a checksum from the clipboard against the file hash of any file on the computer. It supports MD5, SHA-1, SHA-256, SHA-384, and SHA-512.

This program is written using the [AutoIt Scripting Language](https://www.autoitscript.com/).

## Compilation

1. Install [AutoIt](https://www.autoitscript.com/).
2. Run one of the build scripts from the project folder.

## Installation

1. Compile the program.
2. Run the compiled installer located in the dist folder.

## Usage

1. Copy a checksum into the clipboard.
2. Open File Explorer and locate the file you want to compare the checksum against.
3. Right-click the file and choose "Compare Checksum from Clipboard" in the context menu.
4. The program will automatically figure out which of the supported algorithms to use, then it calculates the hash of the file before it compares the result with the checksum from the clipboard and produces a message box indicating success or failure.

## Notes

1. AntiVirus software, including Windows Defender, has a tendency of falsely flagging programs made with AutoIt as harmful. If building the 32 bits version fails because of this, then you could try building the 64 bits version instead and hope for the best.
