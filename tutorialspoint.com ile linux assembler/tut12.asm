; tut12.asm: Kodlamalý 2 sayýnýn bölüm sonucunun ekrana yazdýrýlmasý örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 8 / 2 = 4
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===ARÝTMETÝK KOMUTLAR===
; DIV/IDIV böUzunluk ; IntegerDivision, iþaretli sayý
; AX/byte=AL/bölüm, AH/kalan
; DX:AX/kelime=AX/bölüm, DX/kalan
; EDX:EAX/çiftkelime=EAX/bölüm, EDX/kalan
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov ax, "8"
    sub ax, "0"
    mov bl, "2"
    sub bl, "0"
    div bl	; ax /= bl
    add ax, "0"
    mov [sonuç], ax

    mov ecx, Mesaj
    mov edx, Uzunluk
    mov ebx,1	; 1=ekran
    mov eax, 4	; 4=yaz
    int 0x80		; kernel

    mov ecx, sonuç
    mov edx, 1	; uzunluk=1 byte
    mov ebx,1
    mov eax, 4
    int 0x80

    mov eax, 1	; 1= çýk
    int 0x80

	section .data
    Mesaj db "8 / 2 = ", 0xA, 0xD
    Uzunluk equ $- Mesaj

	segment .bss
    sonuç resb 1