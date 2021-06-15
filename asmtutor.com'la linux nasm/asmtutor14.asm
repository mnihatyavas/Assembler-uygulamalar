; asmtutor14.asm:  �ki kay�t��daki tamsay�lar�n �arp��n�n ekrana yans�t�lmas� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 90 * 75 = 6750
;----------------------------------------------------------------------------------------------------------------------------------
; ===14.Tamsay� �arpma===
; EAX kay�t��ya 90, EBX'e 75 konulup, MUL ile bu ikisinin �arp�m� EAX'da �arp�l�p tyazAS (Tamsay�YazAltSat�r) ile
; sonu� yazd�r�lacakt�r.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "90 * 75 = ", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj
    call dyaz	; Altsat�ra ge�meden sa��na sonu� yazd�r�lacak
    mov eax, 90
    mov ebx, 75
    mul ebx		; EAX *=EBX (=6750)
    call tyazAS
    call son