; asmtutor28.asm: SYS_UNLINK ile mevcut disk dosyanýn silinmesi örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
;----------------------------------------------------------------------------------------------------------------------------------
; ===28.Disk Dosyasýnýn Silinmesi===
; EBX=Dosya adý, EAX=10=SYS_UNLINK
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAdý db "mny1.txt", 0h

	SECTION .text
    global _start
_start:
    mov ebx, DosyaAdý
    mov eax, 10	; Baþvur (10=SYS_UNLINK)
    int 80h

    call son