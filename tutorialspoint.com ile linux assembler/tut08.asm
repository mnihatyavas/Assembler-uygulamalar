; tut08.asm:  EQU tanýmlý sabitlerle ekrana mesajlar yazdýrma örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
: Programcýlara selamlar!
; Çevrimiçi linux assembler programcýlýðýna, hepiniz hoþgeldiniz!
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===SABÝTLER===
; Sabitleri tanýmlamada EQU/Equal/Eþit, %assign/Tahsiset, %define/Tanýmla direktifleri kullanýlmaktadýr.
; ÖÐRENCÝ_SAYISI EQU 50
; mov ecx, ÖÐRENCÝ_SAYISI
; cmp eax, ÖÐRENCÝ_SAYISI
; BOY equ 20
; EN equ 10
; ALAN equ en * boy		; 10*20=200
;----------------------------------------------------------------------------------------------------------------------------------------------

    ÇIK equ 1	; sys_exit
    YAZ equ 4	; sys_write
    KLAVYE equ 0	; stdin
    EKRAN equ 1	; stdout

	section .text
    global _start
_start:
    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, Mesaj1
    mov edx, Uzunluk1
    int 0x80

    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, Mesaj2
    mov edx, Uzunluk2
    int 0x80

    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, Mesaj3
    mov edx, Uzunluk3
    int 0x80

    mov eax, ÇIK
    int 0x80		; Çýkýþ iþlemini gerçekleþtir

	section .data
    Mesaj1 db "Programcýlara selamlar!", 0xA, 0xD
    Uzunluk1 equ $ - Mesaj1
    Mesaj2 db "Çevrimiçi linux assembler programcýlýðýna, ", 0xA
    Uzunluk2 equ $ - Mesaj2
    Mesaj3 db "hepiniz hoþgeldiniz!"
    Uzunluk3 equ $- Mesaj3