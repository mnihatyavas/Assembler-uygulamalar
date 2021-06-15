; asmtutor21.asm: SYS_TIME ile 1.1.1970'den beri ge�en saniyeler �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 1 Ocak 1970'den beri ge�en saniye: 1623464602
;----------------------------------------------------------------------------------------------------------------------------------
; ===21.Ge�en Sistem Zaman�===
; EAX=13 sys_time fonsiyonunna ba�vurarak, 1.1.1970'den beri ge�en saniyeleri yans�t�r.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "1 Ocak 1970'den beri ge�en saniye: ", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj
    call dyaz
    mov eax, 13	; Ba�vur 13=SYS_TIME
    int 80h		; D�nen de�er EAX'tad�r

    call tyazAS
    call son