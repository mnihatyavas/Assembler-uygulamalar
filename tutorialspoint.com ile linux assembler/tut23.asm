; tut23.asm: Mesaj ve uzunlu�u girilen iki parametreli ekrana yazd�rma makro tan�m� �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Merhaba programc�lar!
; Linux assembler programc�l�k 
; d�nyas�na ho�geldiniz!
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===MAKROLAR===
; Bir kodlama grubu program i�inde farkl� parametrik de�erlerle aynen kullan�lacaksa, her keresinde t�m
; kdlamay� tekrar tekrar yazmak yerine:
; %macro makro_ad� parametre_say�s�
; ...makro kodlamalar
; %endmacro
; ve program i�inde:
; makro_ad� param1, param2,...
; �eklinde invoke/call �a�r�/ba�vuru yap�l�r.
;----------------------------------------------------------------------------------------------------------------------------------------------

; �ki parametreli bir makro ekrana yazd�rma ba�urusu yapacak. Makro tan�m�:
%macro dizgeyi_ekrana_yaz 2
    mov eax, 4	; 4=yaz
    mov ebx, 1	; 1=ekran
    mov ecx, %1	; Mesaj
    mov edx, %2	; Uzunluk
    int 80h
%endmacro

	section .text
global _start
_start:
    dizgeyi_ekrana_yaz Mesaj1, Uzunluk1
    dizgeyi_ekrana_yaz Mesaj2, Uzunluk2
    dizgeyi_ekrana_yaz Mesaj3, Uzunluk3

    mov eax, 1	; 1=��k
    int 0x80		; 80H=kernel'i �a��r

	section .data
    Mesaj1 db "Merhaba programc�lar!", 0xA, 0xD
    Uzunluk1 equ $ - Mesaj1

    Mesaj2 db "Linux assembler programc�l�k ", 0xA, 0xD
    Uzunluk2 equ $- Mesaj2

    Mesaj3 db "d�nyas�na ho�geldiniz!", 0xA, 0
    Uzunluk3 equ $- Mesaj3