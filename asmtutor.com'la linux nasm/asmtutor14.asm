; asmtutor14.asm:  Ýki kayýtçýdaki tamsayýlarýn çarpýýnýn ekrana yansýtýlmasý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 90 * 75 = 6750
;----------------------------------------------------------------------------------------------------------------------------------
; ===14.Tamsayý Çarpma===
; EAX kayýtçýya 90, EBX'e 75 konulup, MUL ile bu ikisinin çarpýmý EAX'da çarpýlýp tyazAS (TamsayýYazAltSatýr) ile
; sonuç yazdýrýlacaktýr.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "90 * 75 = ", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj
    call dyaz	; Altsatýra geçmeden saðýna sonuç yazdýrýlacak
    mov eax, 90
    mov ebx, 75
    mul ebx		; EAX *=EBX (=6750)
    call tyazAS
    call son