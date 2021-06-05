; tut12.asm: Kodlamal� 2 say�n�n b�l�m sonucunun ekrana yazd�r�lmas� �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 8 / 2 = 4
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===AR�TMET�K KOMUTLAR===
; DIV/IDIV b�Uzunluk ; IntegerDivision, i�aretli say�
; AX/byte=AL/b�l�m, AH/kalan
; DX:AX/kelime=AX/b�l�m, DX/kalan
; EDX:EAX/�iftkelime=EAX/b�l�m, EDX/kalan
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
    mov [sonu�], ax

    mov ecx, Mesaj
    mov edx, Uzunluk
    mov ebx,1	; 1=ekran
    mov eax, 4	; 4=yaz
    int 0x80		; kernel

    mov ecx, sonu�
    mov edx, 1	; uzunluk=1 byte
    mov ebx,1
    mov eax, 4
    int 0x80

    mov eax, 1	; 1= ��k
    int 0x80

	section .data
    Mesaj db "8 / 2 = ", 0xA, 0xD
    Uzunluk equ $- Mesaj

	segment .bss
    sonu� resb 1