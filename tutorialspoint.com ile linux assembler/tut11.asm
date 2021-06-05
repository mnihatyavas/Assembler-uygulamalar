; tut11.asm: Kodlamalý 2 sayýnýn çarpým sonucunun ekrana yazdýrýlmasý örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 3 * 2 = 6
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===ARÝTMETÝK KOMUTLAR-3===
; MUL/IMUL çarpan	; çarpýlan eax, IMUL/IntegerMultiply/iþaretli
; 1) AL*byte=AH+AL
; 2) AX*kelime=DX+AX
; 3) EAX*çiftkelime=EDX+EAX
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
    sub al, "0"	; ascii'den ondalýða
    mov bl, "2"
    sub bl, "0"
    mul bl		; al *=bl
    add al, "0"	; ondalýktan ascii'ye
    mov [sonuç], al

    mov ecx, Mesaj
    mov edx, Uzunluk
    mov ebx,1	; 1=ekran
    mov eax, 4	; 4=yaz
    int 0x80		; kernel

    mov ecx, sonuç
    mov edx, 1
    mov ebx,1	; 1=ekran
    mov eax,4	; 4=yaz
    int 0x80		; kernel

    mov eax,1	; 1=çýk
    int 0x80		; kernel

	section .data
    Mesaj db "3 * 2 = ", 0xA, 0xD
    Uzunluk equ $- Mesaj

	segment .bss
    sonuç resb 1