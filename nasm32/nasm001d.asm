; nasm001d.asm: Dosya yazma rutiniyle merhaba dünya örneði.
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
    push (mesaj_sonu - mesaj)
    push mesaj
    push ebx
    call _WriteFile@20

    ; ExitProcess (0)
    push 0
    call _ExitProcess@4

    ; buraya gelmeden programý bitirin
    hlt
mesaj:
    db "Merhaba, Nasm32 Dünyasý", 10
mesaj_sonu: