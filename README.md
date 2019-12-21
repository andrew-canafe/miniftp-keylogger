# Mini-FTP-Keylogger
Fully-functional FTP keylogger (2015) that I wrote during my free time. Written in x86-64 assembly language. Use at your own risk!

## Details:
- Runs on 64-bit Windows
- Written in pure assembly
- Only 4 KB in size

## Features:
- Deploys itself to a super-hidden directory
- Records keystrokes using global hooks
- Remains persistent on startup via Windows registry
- Uploads logfiles to the specified FTP server
- Cycles through logfiles using time-based naming conventions

## How to use:
1. Open miniftpkeylogger.asm and edit the username, password, and server name fields
2. Assemble using MASM64 to create miniftpkeylogger.exe
3. Use miniftpkeylogger.exe at your own risk

## How to safely remove:
1. Open up Task Manager -> Find ccsvchst.exe -> Right click -> End task
2. Open up Registry Editor -> Software\Microsoft\Windows\CurrentVersion\Run -> Find Startup -> Right click -> Delete
3. Open up Explorer -> View -> Make sure the "Hidden items" box is checked
4. Go to %APPDATA% and delete the Startup folder and its contents
5. Optional: delete all files uploaded to the FTP server
