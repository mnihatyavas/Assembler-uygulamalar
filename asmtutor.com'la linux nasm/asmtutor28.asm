; asmtutor28.asm: SYS_UNLINK ile mevcut disk dosyan�n silinmesi �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
;----------------------------------------------------------------------------------------------------------------------------------
; ===28.Disk Dosyas�n�n Silinmesi===
; EBX=Dosya ad�, EAX=10=SYS_UNLINK
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAd� db "mny1.txt", 0h

	SECTION .text
    global _start
_start:
    mov ebx, DosyaAd�
    mov eax, 10	; Ba�vur (10=SYS_UNLINK)
    int 80h

    call son