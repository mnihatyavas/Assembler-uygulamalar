; ----------------------------------------------------------------------------
; nasm001e.asm: C kütüphanesiz, kernel32.dll ile merhaba dünya örneði.
;
; http://forum.codecall.net/topic/65222-intro-to-win32-assembly-using-nasm-part-1/..100
; nasm -fwin32 nasm001e.asm
; gcc -m32 nasm001e.obj
; ----------------------------------------------------------------------------

    global _main

    extern _ExitProcess@4
    extern _GetStdHandle@4
    extern _WriteConsoleA@20

	section .data
Mesaj: db "Merhaba, kernel32.dll Win32 sistemli assembler programý!..", 10
Yönet: db 0
Yazýldý: db 0

	section .text
_main:
    ; Yönet = GetStdHandle (-11)
    push dword -11
    call _GetStdHandle@4
    mov [Yönet], eax

    ; WriteConsole (yönet, &mesaj[0], 60, &yazýldý, 0)
    push dword 0
    push Yazýldý
    push dword 60
    push Mesaj
    push dword [Yönet]
    call _WriteConsoleA@20

    ; ExitProcess (0)
    push dword 0
    call _ExitProcess@4