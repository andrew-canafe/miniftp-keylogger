# Miniftp Keylogger
Proof-of-concept FTP keylogger (updated in 2020) that I wrote during my free time. Written in x86-64 assembly language. Use for educational purposes only, and at your own risk!

## Details:
- Runs on 64-bit Windows
- Written in pure assembly
- Only 4 KB in size

## Features:
- Deploys itself to a super-hidden directory
- Records keystrokes using global hooks
- Remains persistent on user login via Windows registry
- Uploads logfiles to the specified FTP server
- Uploads logfiles to a unique directory created by the client
- Cycles through logfiles using time-based naming conventions

## How to use:
You may first need to [temporarily disable Windows Defender](https://github.com/andrewcanafe/Mini-FTP-Keylogger/blob/master/README.md#how-to-temporarily-disable-windows-defender). However, this can be bypassed by using dynamic encryption tools, renaming the file to a less suspicious name, etc. Running a newer version of the keylogger will automatically overwrite an older version, and vice versa.
1. Open miniftp.asm and edit the username, password, and server name fields
2. Assemble using ml64.exe and link.exe (see build.bat) to create miniftp.exe
3. Use miniftp.exe at your own risk!

## How to safely remove:
1. Open up Task Manager > Find ccsvchst.exe and end task
2. Open up Registry Editor > HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run > Find the Startup value and delete
2. Open up Registry Editor > HKEY_CURRENT_USER\Software > Find the Startup key and delete
3. Open up Explorer > View > Options > View > Hidden files and folders > Make sure "Show hidden files, folders, and drives" is selected
3. Open up Explorer > View > Options > View > Make sure "Hide protected operating system files" is unchecked
3. Open up Explorer > View > Make sure "Hidden items" is checked
4. Go to %APPDATA% and delete the Startup folder and its contents
5. **OPTIONAL: delete all files uploaded to the FTP server**

## How to temporarily disable Windows Defender:
1. Open up Windows Security > Virus & threat protection > Virus & threat protection settings > Manage settings > Make sure "Real-time protection" is turned off
