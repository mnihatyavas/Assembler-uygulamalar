; tut23.asm: Mesaj ve uzunluðu girilen iki parametreli ekrana yazdýrma makro tanýmý örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Merhaba programcýlar!
; Linux assembler programcýlýk 
; dünyasýna hoþgeldiniz!
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===MAKROLAR===
; Bir kodlama grubu program içinde farklý parametrik deðerlerle aynen kullanýlacaksa, her keresinde tüm
; kdlamayý tekrar tekrar yazmak yerine:
; %macro makro_adý parametre_sayýsý
; ...makro kodlamalar
; %endmacro
; ve program içinde:
; makro_adý param1, param2,...
; þeklinde invoke/call çaðrý/baþvuru yapýlýr.
;----------------------------------------------------------------------------------------------------------------------------------------------

; Ýki parametreli bir makro ekrana yazdýrma baþurusu yapacak. Makro tanýmý:
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

    mov eax, 1	; 1=çýk
    int 0x80		; 80H=kernel'i çaðýr

	section .data
    Mesaj1 db "Merhaba programcýlar!", 0xA, 0xD
    Uzunluk1 equ $ - Mesaj1

    Mesaj2 db "Linux assembler programcýlýk ", 0xA, 0xD
    Uzunluk2 equ $- Mesaj2

    Mesaj3 db "dünyasýna hoþgeldiniz!", 0xA, 0
    Uzunluk3 equ $- Mesaj3