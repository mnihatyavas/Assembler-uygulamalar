; tut17.asm:  AAS ile çýkarma sonucunu sayýsaldan ascii'ye çevirme örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 9 - 3 = 6
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===SAYILAR===
; Sayýlar klavyeden girilirken yada ekranda görülürken ascii'ye çevrilir, aritmetik iþlem esnasýndaysa ikili
; formdadýrlar. Kolaylýk olsun diye byte sayý iki haneli ve her dörder bit tek hex sembolle gösterilebilir, desimal
; de olabilir.
; Ondalýk sayýlar bilgisayarda ASCII veya BCD/BinaryCodedDecimal yöntemlerden biriyle iþlenirler.
; ASCII yöntemde 1234 sayýsýnýn depolanmasý ascii karþýlýklarý: 31 32 33 34H olarak yapýlýr.
; Ascii iþlem komutlarý: AAA/AsciiAdjustafterAddition, AAS/AsciiAdjustafterSubtraction,
; AAM/AsciiAdjustafterMultiplication, AAD/AsciiAdjustbeforeDivision
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    sub ah, ah	; AH=0
    mov al, "9"	; AL=9=0000 1001
    sub al, "3"	; AL=6=0000 0110
    AAS		; AsciiAdjustafterSubtraction=0010 0100=26H ascii
    or al, 30h	; 0010 0100 OR 0011 0000=0011 0100=36H
    mov [sonuç], ax
    mov edx,Uzunluk
    mov ecx, Mesaj
    mov ebx,1
    mov eax, 4
    int 0x80

    mov edx,1
    mov ecx, sonuç
    mov ebx,1
    mov eax,4
    int 0x80

    mov eax,1
    int 0x80

	section .data
    Mesaj db "9 - 3 = ", 0xa
    Uzunluk equ $ - Mesaj

	section .bss
    sonuç resb 1