; tut14.asm: Verili iki say�n�n OR sonucu �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 7
;----------------------------------------------------------------------------------------------------------------------------------------------
; MANTIKSAL KOMUTLAR-2===
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov al, 5	; 0000 0101
    mov bl, 3	; 0000 0011
    or al, bl		; 0000 0111 =7D
    add al, byte "0"	; ondal�ktan ascii'ye
    mov [sonu�], al

    mov eax, 4
    mov ebx, 1
    mov ecx, sonu�
    mov edx, 1
    int 0x80

��k��:
    mov eax,1
    int 0x80

	section .bss
    sonu� resb 1