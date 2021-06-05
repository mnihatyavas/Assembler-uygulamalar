; tut17.asm:  AAS ile ��karma sonucunu say�saldan ascii'ye �evirme �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 9 - 3 = 6
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===SAYILAR===
; Say�lar klavyeden girilirken yada ekranda g�r�l�rken ascii'ye �evrilir, aritmetik i�lem esnas�ndaysa ikili
; formdad�rlar. Kolayl�k olsun diye byte say� iki haneli ve her d�rder bit tek hex sembolle g�sterilebilir, desimal
; de olabilir.
; Ondal�k say�lar bilgisayarda ASCII veya BCD/BinaryCodedDecimal y�ntemlerden biriyle i�lenirler.
; ASCII y�ntemde 1234 say�s�n�n depolanmas� ascii kar��l�klar�: 31 32 33 34H olarak yap�l�r.
; Ascii i�lem komutlar�: AAA/AsciiAdjustafterAddition, AAS/AsciiAdjustafterSubtraction,
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
    mov [sonu�], ax
    mov edx,Uzunluk
    mov ecx, Mesaj
    mov ebx,1
    mov eax, 4
    int 0x80

    mov edx,1
    mov ecx, sonu�
    mov ebx,1
    mov eax,4
    int 0x80

    mov eax,1
    int 0x80

	section .data
    Mesaj db "9 - 3 = ", 0xa
    Uzunluk equ $ - Mesaj

	section .bss
    sonu� resb 1