; ----------------------------------------------------------------------------
; nasm001e.asm: C kütüphanesiz, kernel32.dll ile merhaba dünya örneði.
;
; http://forum.codecall.net/topic/65222-intro-to-win32-assembly-using-nasm-part-1/..100
; ----------------------------------------------------------------------------

    global _main

    extern _ExitProcess@4
    extern _GetStdHandle@4
    extern _WriteConsoleA@20

	section .data
mesaj: db "Merhaba, kernel32.dll Win32 sistemli assembler programý!..", 10
yönet: db 0
yazýldý: db 0

	section .text
_main:
    ; yönet = GetStdHandle (-11)
    push dword -11
    call _GetStdHandle@4
    mov [yönet], eax

    ; WriteConsole (yönet, &mesaj[0], 60, &yazýldý, 0)
    push dword 0
    push yazýldý
    push dword 60
    push mesaj
    push dword [yönet]
    call _WriteConsoleA@20

    ; ExitProcess (0)
    push dword 0
    call _ExitProcess@4