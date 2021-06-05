; tut22.asm: Kendini dolaylý çaðýran altrutinle faktöryel hesabý örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Faktoryel 3 = 6
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===KENDÝNÝ ÇAÐIRAN ALTRUTÝN ===
; Bir altrutin kendini kendi içinden doðrudan çaðýrabilir, yada ikinci altrutini çaðýrýr, o da tekrar ilkini dolaylý çaðýrýr.
; Algoritmik örnek: fact (n) = n * fact (n-1) for n > 0
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
     global _start
_start:
mov bx, 3		; 3! = 3*2*1=6 hesaplayacak
     call faktöryel_altrutini	; al=6
     add ax, 30h		; ascii 36h?..
     mov [faktöryel], ax

     mov edx, Uzunluk
     mov ecx, Mesaj
     mov ebx, 1
     mov eax, 4
     int 0x80

     mov edx, 1
     mov ecx, faktöryel
     mov ebx, 1
     mov eax, 4
     int 0x80

     mov eax, 1
     int 0x80

faktöryel_altrutini:
     cmp bl, 1
     jg hesaplamayý_yap	; JumpGreater > 1
     mov ax, 1
     ret

hesaplamayý_yap:
     dec bl
     call faktöryel_altrutini	; n * fact (n - 1), eðer n > 1
     inc bl
     mul bl			; ax = al * bl
     ret

	section .data
     Mesaj db "Faktöryel 5 = ", 0xa
     Uzunluk equ $ - Mesaj

	section .bss
     faktöryel resb 1