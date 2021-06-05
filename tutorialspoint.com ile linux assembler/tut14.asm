; tut14.asm: Verili iki sayýnýn OR sonucu örneði.
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
    add al, byte "0"	; ondalýktan ascii'ye
    mov [sonuç], al

    mov eax, 4
    mov ebx, 1
    mov ecx, sonuç
    mov edx, 1
    int 0x80

çýkýþ:
    mov eax,1
    int 0x80

	section .bss
    sonuç resb 1