; tut08.asm:  EQU tan�ml� sabitlerle ekrana mesajlar yazd�rma �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
: Programc�lara selamlar!
; �evrimi�i linux assembler programc�l���na, hepiniz ho�geldiniz!
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===SAB�TLER===
; Sabitleri tan�mlamada EQU/Equal/E�it, %assign/Tahsiset, %define/Tan�mla direktifleri kullan�lmaktad�r.
; ��RENC�_SAYISI EQU 50
; mov ecx, ��RENC�_SAYISI
; cmp eax, ��RENC�_SAYISI
; BOY equ 20
; EN equ 10
; ALAN equ en * boy		; 10*20=200
;----------------------------------------------------------------------------------------------------------------------------------------------

    �IK equ 1	; sys_exit
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

    mov eax, �IK
    int 0x80		; ��k�� i�lemini ger�ekle�tir

	section .data
    Mesaj1 db "Programc�lara selamlar!", 0xA, 0xD
    Uzunluk1 equ $ - Mesaj1
    Mesaj2 db "�evrimi�i linux assembler programc�l���na, ", 0xA
    Uzunluk2 equ $ - Mesaj2
    Mesaj3 db "hepiniz ho�geldiniz!"
    Uzunluk3 equ $- Mesaj3