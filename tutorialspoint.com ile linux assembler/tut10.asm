; tut10.asm: Kodlamayla girilen 2 say�n�n toplam�n� yazd�rma �rne�i.
;
;$nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
;$demo
;3 + 5 = 8
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===AR�TMET�K KOMUTLAR-2===
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov eax, "3"
    sub eax, "0"	; ascii ondal��a �evrilir
    mov ebx, "5"
    sub ebx, "0"	; ascii ondal��a �evrilir
    add eax, ebx	; eax += ebx
    add eax, "0"	; ondal�k ascii'ye �evrilir
    mov [toplam], eax	; toplam=eax=8
    mov ecx, Mesaj
    mov edx, Uzunluk
    mov ebx,1	; 1=ekran
    mov eax, 4	; 4=yaz
    int 0x80		; kernel'i �a��r

    mov ecx, toplam
    mov edx, 1
    mov ebx,1
    mov eax, 4
    int 0x80

    mov eax,1	; 1=��k
    int 0x80

	section .data
    Mesaj db "3 + 5 = ", 0xA,0xD
    Uzunluk equ $ - Mesaj

	segment .bss
    toplam resb 1