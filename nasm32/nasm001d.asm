; nasm001d.asm: Dosya yazma rutiniyle merhaba dünya örneði.
;
; nasm -fwin32 nasm001d.asm
; gcc -m32 nasm001d.obj
;-----------------------------------------------------------------------------------------------------
    global _main
    extern  _GetStdHandle@4
    extern  _WriteFile@20
    extern  _ExitProcess@4

	section .text
_main:
    ; DWORD  bytes;    
    mov ebp, esp
    sub esp, 4

    ; hStdOut = GetstdHandle (STD_OUTPUT_HANDLE)
    push -11
    call _GetStdHandle@4
    mov ebx, eax    

    ; WriteFile (hstdOut, message, length (message), &bytes, 0);
    push 0
    lea eax, [ebp-4]
    push eax
    push (Mesaj_sonu - Mesaj)
    push Mesaj
    push ebx
    call _WriteFile@20

    ; ExitProcess (0)
    push 0
    call _ExitProcess@4

    ; buraya gelmeden programý bitirin
    hlt

	segment .data
Mesaj:
    db "Merhaba, Nasm32 Dünyasý", 10
Mesaj_sonu: