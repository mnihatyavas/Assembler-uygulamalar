; asmtutor13.asm:  Ýki kayýtçýdaki tamsayýlarýn farkýnýn ekrana yansýtýlmasý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 90 - 75 = 15
;----------------------------------------------------------------------------------------------------------------------------------
; ===13.Tamsayý Çýkarma===
; EAX kayýtçýya 90, EBX'e 75 konulup, SUB ile bu ikisinin farký EAX'da çýkarýlýp tyazAS (TamsayýYazAltSatýr) ile
; sonuç yazdýrýlacaktýr.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "90 - 75 = ", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj
    call dyaz	; Altsatýra geçmeden saðýna sonuç yazdýrýlacak
    mov eax, 90
    mov ebx, 75
    sub eax, ebx	; EAX -=EBX (=15)
    call tyazAS
    call son