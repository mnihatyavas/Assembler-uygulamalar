; asmtutor21.asm: SYS_TIME ile 1.1.1970'den beri geçen saniyeler örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 1 Ocak 1970'den beri geçen saniye: 1623464602
;----------------------------------------------------------------------------------------------------------------------------------
; ===21.Geçen Sistem Zamaný===
; EAX=13 sys_time fonsiyonunna baþvurarak, 1.1.1970'den beri geçen saniyeleri yansýtýr.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "1 Ocak 1970'den beri geçen saniye: ", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj
    call dyaz
    mov eax, 13	; Baþvur 13=SYS_TIME
    int 80h		; Dönen deðer EAX'tadýr

    call tyazAS
    call son