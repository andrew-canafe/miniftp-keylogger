ml64.exe /c miniftp.asm
link.exe /subsystem:windows /entry:start miniftp.obj /out:miniftp.exe
pause