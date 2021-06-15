; asmtutor15.asm:  �ki kay�t��daki tamsay�lar�n b�l�m�n�n ekrana yans�t�lmas� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Tamsay� b�l�m (90 / 75) = 1

; Tamsay� kalan (90 / 75) = 15
;----------------------------------------------------------------------------------------------------------------------------------
; ===15.Tamsay� B�lme===
; EAX kay�t��ya 90, EBX'e 75 konulup, DIV ile bu ikisinin tamsay� b�l�m� EAX'a, tamsay� kalan� da EDX'e
; konulup tyazAS (Tamsay�YazAltSat�r) ile b�l�m ve kalan ayr� ayr� ekrana yazd�r�lacakt�r.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj1 db "Tamsay� b�l�m (90 / 75) = ", 0h
    Mesaj2 db "Tamsay� kalan (90 / 75) = ", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj1
    call dyaz	; Altsat�ra ge�meden sa��na sonu� yazd�r�lacak
    mov eax, 90
    mov ebx, 75
    div ebx		; EAX /=EBX (=1, EDX=15)
    call tyazAS
    mov eax, Mesaj2
    call dyaz
    mov eax, edx
    call tyazAS
    call son