; tut11.asm: Kodlamal� 2 say�n�n �arp�m sonucunun ekrana yazd�r�lmas� �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 3 * 2 = 6
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===AR�TMET�K KOMUTLAR-3===
; MUL/IMUL �arpan	; �arp�lan eax, IMUL/IntegerMultiply/i�aretli
; 1) AL*byte=AH+AL
; 2) AX*kelime=DX+AX
; 3) EAX*�iftkelime=EDX+EAX
;
; MOV AL, 10
; MOV DL, 25
; MUL DL
;
; MOV DL, 0FFH	; DL= -1
; MOV AL, 0BEH	; AL = -66
; IMUL DL
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov al, "3"
    sub al, "0"	; ascii'den ondal��a
    mov bl, "2"
    sub bl, "0"
    mul bl		; al *=bl
    add al, "0"	; ondal�ktan ascii'ye
    mov [sonu�], al

    mov ecx, Mesaj
    mov edx, Uzunluk
    mov ebx,1	; 1=ekran
    mov eax, 4	; 4=yaz
    int 0x80		; kernel

    mov ecx, sonu�
    mov edx, 1
    mov ebx,1	; 1=ekran
    mov eax,4	; 4=yaz
    int 0x80		; kernel

    mov eax,1	; 1=��k
    int 0x80		; kernel

	section .data
    Mesaj db "3 * 2 = ", 0xA, 0xD
    Uzunluk equ $- Mesaj

	segment .bss
    sonu� resb 1