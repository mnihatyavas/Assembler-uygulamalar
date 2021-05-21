; ----------------------------------------------------------------------------
; nasm001e.asm: C k�t�phanesiz, kernel32.dll ile merhaba d�nya �rne�i.
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
Mesaj: db "Merhaba, kernel32.dll Win32 sistemli assembler program�!..", 10
Y�net: db 0
Yaz�ld�: db 0

	section .text
_main:
    ; Y�net = GetStdHandle (-11)
    push dword -11
    call _GetStdHandle@4
    mov [Y�net], eax

    ; WriteConsole (y�net, &mesaj[0], 60, &yaz�ld�, 0)
    push dword 0
    push Yaz�ld�
    push dword 60
    push Mesaj
    push dword [Y�net]
    call _WriteConsoleA@20

    ; ExitProcess (0)
    push dword 0
    call _ExitProcess@4