; asmtutor12.asm:  �ki kay�t��daki tamsay�lar�n toplan�p ekrana yans�t�lmas� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 90 + 75 = 165
;----------------------------------------------------------------------------------------------------------------------------------
; ===12.Tamsay� Toplama===
; EAX kay�t��ya 90, EBX'e 75 konulup, ADD ile bu ikisi EAX'da toplan�p tyazAS (Tamsay�YazAltSat�r) ile
; sonu� yazd�r�lacakt�r.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "90 + 75 = ", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj
    call dyaz	; Altsat�ra ge�meden sa��na sonu� yazd�r�lacak
    mov eax, 90
    mov ebx, 75
    add eax, ebx	; EAX +=EBX (=165)
    call tyazAS
    call son