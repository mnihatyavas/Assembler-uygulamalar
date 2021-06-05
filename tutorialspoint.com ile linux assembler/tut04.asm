; tut04.asm: Klavyeden girilen say�lar�n ekranda yans�t�lmas� �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; L�tfen bir say� girin: 12345
; Girdi�iniz say�: 12345
;--------------------------------------------------------------------------------------------------------------------------
; ===S�STEM �A�RILARI===
; Linux assembler sistem �a�r�lar�ndan yaz (mov eax,4) ve ��k (mov eax,1) sonras� linux �a�r� kodu (int 0x80) i�lendi.
; Ayr�ca ekrana mesaj yazd�rmak i�in �e�itli kay�t��lara de�erler y�klenip kernel �a�r�ld�:mov edx,4 ; message length
; mov ecx, Mesaj	; yazd�r�lacak mesaj
; mov ebx,1	; yazd�r�lacak dosya no (stdout=1), ekran
; mov eax, 4	; sistem �a�r� no (sys_write=4), yaz
; int 0x80		; kernel �a�r�l�r
;
; eax'a yazd�r�lacak baz� sistem �a�r� no'lar�:
; eax  �a�r�_ad�   ebx                     ecx                 edx     esx   edi
; 1      sys_exit      int
; 2      sys_fork     struct pt_regs
; 3      sys_read    unsigned int      char *              size_t
; 4      sys_write    unsigned int      const char *   size_t
; 5      sys_open   const char *       int                    int
; 6      sys_close   unsigned int
;--------------------------------------------------------------------------------------------------------------------------

	section .data
    girisMesaji db "L�tfen bir say� girin: "
    girisMesajUzunlugu equ $-girisMesaji
    cikisMesaji db "Girdi�iniz say�: "
    cikisMesajUzunlugu equ $-cikisMesaji

	section .bss
    sayi resb 5

	section .text
     global _start
_start:
; Say� giri� mesaj�n� yans�t
    mov eax, 4	; sys_write
    mov ebx, 1	; stdout, ekran
    mov ecx, girisMesaji
    mov edx, girisMesajUzunlugu
    int 80h		; kernel call

; Klavyeden girileni oku ve depola
    mov eax, 3	; sys_read
    mov ebx, 2	; stdin, klavye
    mov ecx, sayi
    mov edx, 5	; 5 bytes (4 say�, 1 -+ i�areti i�in)
    int 80h

; Say� ��k�� mesaj�n� yans�t
    mov eax, 4
    mov ebx, 1
    mov ecx, cikisMesaji
    mov edx, cikisMesajUzunlugu
    int 80h

; Girilip depolanan say�y� yans�t
    mov eax, 4
    mov ebx, 1
    mov ecx, sayi
    mov edx, 5
    int 80h

; ��k�� kodu
    mov eax, 1	; sys_exit
    mov ebx, 0
    int 80h