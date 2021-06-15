; asmtutor13.asm:  �ki kay�t��daki tamsay�lar�n fark�n�n ekrana yans�t�lmas� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 90 - 75 = 15
;----------------------------------------------------------------------------------------------------------------------------------
; ===13.Tamsay� ��karma===
; EAX kay�t��ya 90, EBX'e 75 konulup, SUB ile bu ikisinin fark� EAX'da ��kar�l�p tyazAS (Tamsay�YazAltSat�r) ile
; sonu� yazd�r�lacakt�r.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "90 - 75 = ", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj
    call dyaz	; Altsat�ra ge�meden sa��na sonu� yazd�r�lacak
    mov eax, 90
    mov ebx, 75
    sub eax, ebx	; EAX -=EBX (=15)
    call tyazAS
    call son