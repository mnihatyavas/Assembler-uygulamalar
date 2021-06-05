; tut13.asm: Kodlamayla girilen say�n�n �ift/tek-say� oldu�unun AND'le tespiti �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 8h �ift say�d�r!
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===MANTIKSAL KOMUTLAR===
; Mant�ksal komutlar: AND/VE, OR/VEYA, XOR/FARKLIYSA i�lemci1 i�lemci2, TEST/Tek�ift, NOT/DE��L i�emci1
;  Kontrol bayraklar�: CF, OF, PF, SF, ZF
; AND BL, 0FH ; BL: 0011 1010, sonu�: 0000 1010
;
; AND AL, 01H ; 0000 0001 
; JZ ��FT_SAYI ; AND sonucu s�f�rsa �ift say�d�r
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov ax, 8h	; �ift say� testi: 0000 1000
;    mov ax, 9h	; tek say� testi: 0000 1001
    and ax, 1	; ZF=1
    jz �iftsay�	; �iftsay� etiketine atlar
    mov eax, 4
    mov ebx, 1
    mov ecx, Teksay�_mesaj�
    mov edx, uzunluk2
    int 0x80
    jmp ��k��

�iftsay�:
    mov eax, 4
    mov ebx, 1
    mov ecx, �iftsay�_mesaj�
    mov edx, uzunluk1
    int 0x80

��k��:
    mov eax,1
    int 0x80

	section .data
    �iftsay�_mesaj� db "8h �ift say�d�r!"
    uzunluk1 equ $ - �iftsay�_mesaj�
    Teksay�_mesaj� db "9h tek say�d�r!"
    uzunluk2 equ $ - Teksay�_mesaj�