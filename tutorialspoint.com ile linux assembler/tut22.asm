; tut22.asm: Kendini dolayl� �a��ran altrutinle fakt�ryel hesab� �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Faktoryel 3 = 6
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===KEND�N� �A�IRAN ALTRUT�N ===
; Bir altrutin kendini kendi i�inden do�rudan �a��rabilir, yada ikinci altrutini �a��r�r, o da tekrar ilkini dolayl� �a��r�r.
; Algoritmik �rnek: fact (n) = n * fact (n-1) for n > 0
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
     global _start
_start:
mov bx, 3		; 3! = 3*2*1=6 hesaplayacak
     call fakt�ryel_altrutini	; al=6
     add ax, 30h		; ascii 36h?..
     mov [fakt�ryel], ax

     mov edx, Uzunluk
     mov ecx, Mesaj
     mov ebx, 1
     mov eax, 4
     int 0x80

     mov edx, 1
     mov ecx, fakt�ryel
     mov ebx, 1
     mov eax, 4
     int 0x80

     mov eax, 1
     int 0x80

fakt�ryel_altrutini:
     cmp bl, 1
     jg hesaplamay�_yap	; JumpGreater > 1
     mov ax, 1
     ret

hesaplamay�_yap:
     dec bl
     call fakt�ryel_altrutini	; n * fact (n - 1), e�er n > 1
     inc bl
     mul bl			; ax = al * bl
     ret

	section .data
     Mesaj db "Fakt�ryel 5 = ", 0xa
     Uzunluk equ $ - Mesaj

	section .bss
     fakt�ryel resb 1