; tut06.asm: Kernel yazd�rma �a�r�s�nda kullan�lan 4 kay�t�� �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Evet
;--------------------------------------------------------------------------------------------------------------------------
; ===DE���KENLER===
; D/Define direktifiyle istedi�imiz kadar ilk de�erli/de�ersiz bellek de�i�kenleri tan�mlayabiliriz.
; DB/DefineByte (1 byte), DW/DefineWord (2 byte), DD/DefineDoubleword (4 byte), DQ/DefineQuadword (8 byte),
; DT/DefineTenbyte (10 byte)
; �rnekler:
; tercih DB "e"
; say� DW 3BH	; Hex say�
; eksi_say� DW -12345	; Ondal�k negatif
; b�y�k_say� DQ 123456789
; ger�el_say�1 DD 1.234
; ger�el_say�2 DQ 123.456
;
; Ondal�k say�lar ascii hex-onalt�l��a �evrilip depolan�r. Negatifler 2 tamlay�c�s� +1'e �evrilir. Kayan noktal�lar k�sa 32-bit
; yada uzun 64 bit olarak saklan�r.
;--------------------------------------------------------------------------------------------------------------------------

	section .data
    tercihin DB "Evet"

	section .text
    global _start
_start:
    mov edx,4	; DataRegister, mesaj uzunlu�u
    mov ecx, tercihin	; CounterRegister, yazd�r�lacak mesaj
    mov ebx,1	; BaseRegister, yazd�r�lacak dosya no=1 (stdout)
    mov eax, 4	; AccumulatorRegister, sistem �a��rma no=4 (sys_write: yaz)
    int 0x80		; Kernel �a�r�s�

    mov eax,1	; Sistem �a��rma no=1 (sys_exit: ��k)
    int 0x80		; Kernel �a�r�s�