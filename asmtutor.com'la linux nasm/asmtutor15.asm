; asmtutor15.asm:  Ýki kayýtçýdaki tamsayýlarýn bölümünün ekrana yansýtýlmasý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Tamsayý bölüm (90 / 75) = 1

; Tamsayý kalan (90 / 75) = 15
;----------------------------------------------------------------------------------------------------------------------------------
; ===15.Tamsayý Bölme===
; EAX kayýtçýya 90, EBX'e 75 konulup, DIV ile bu ikisinin tamsayý bölümü EAX'a, tamsayý kalaný da EDX'e
; konulup tyazAS (TamsayýYazAltSatýr) ile bölüm ve kalan ayrý ayrý ekrana yazdýrýlacaktýr.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj1 db "Tamsayý bölüm (90 / 75) = ", 0h
    Mesaj2 db "Tamsayý kalan (90 / 75) = ", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj1
    call dyaz	; Altsatýra geçmeden saðýna sonuç yazdýrýlacak
    mov eax, 90
    mov ebx, 75
    div ebx		; EAX /=EBX (=1, EDX=15)
    call tyazAS
    mov eax, Mesaj2
    call dyaz
    mov eax, edx
    call tyazAS
    call son