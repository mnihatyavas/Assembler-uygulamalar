; asmtutor12.asm:  Ýki kayýtçýdaki tamsayýlarýn toplanýp ekrana yansýtýlmasý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 90 + 75 = 165
;----------------------------------------------------------------------------------------------------------------------------------
; ===12.Tamsayý Toplama===
; EAX kayýtçýya 90, EBX'e 75 konulup, ADD ile bu ikisi EAX'da toplanýp tyazAS (TamsayýYazAltSatýr) ile
; sonuç yazdýrýlacaktýr.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "90 + 75 = ", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj
    call dyaz	; Altsatýra geçmeden saðýna sonuç yazdýrýlacak
    mov eax, 90
    mov ebx, 75
    add eax, ebx	; EAX +=EBX (=165)
    call tyazAS
    call son