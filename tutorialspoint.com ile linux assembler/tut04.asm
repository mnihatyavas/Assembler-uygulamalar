; tut04.asm: Klavyeden girilen sayýlarýn ekranda yansýtýlmasý örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Lütfen bir sayý girin: 12345
; Girdiðiniz sayý: 12345
;--------------------------------------------------------------------------------------------------------------------------
; ===SÝSTEM ÇAÐRILARI===
; Linux assembler sistem çaðrýlarýndan yaz (mov eax,4) ve çýk (mov eax,1) sonrasý linux çaðrý kodu (int 0x80) iþlendi.
; Ayrýca ekrana mesaj yazdýrmak için çeþitli kayýtçýlara deðerler yüklenip kernel çaðrýldý:mov edx,4 ; message length
; mov ecx, Mesaj	; yazdýrýlacak mesaj
; mov ebx,1	; yazdýrýlacak dosya no (stdout=1), ekran
; mov eax, 4	; sistem çaðrý no (sys_write=4), yaz
; int 0x80		; kernel çaðrýlýr
;
; eax'a yazdýrýlacak bazý sistem çaðrý no'larý:
; eax  Çaðrý_adý   ebx                     ecx                 edx     esx   edi
; 1      sys_exit      int
; 2      sys_fork     struct pt_regs
; 3      sys_read    unsigned int      char *              size_t
; 4      sys_write    unsigned int      const char *   size_t
; 5      sys_open   const char *       int                    int
; 6      sys_close   unsigned int
;--------------------------------------------------------------------------------------------------------------------------

	section .data
    girisMesaji db "Lütfen bir sayý girin: "
    girisMesajUzunlugu equ $-girisMesaji
    cikisMesaji db "Girdiðiniz sayý: "
    cikisMesajUzunlugu equ $-cikisMesaji

	section .bss
    sayi resb 5

	section .text
     global _start
_start:
; Sayý giriþ mesajýný yansýt
    mov eax, 4	; sys_write
    mov ebx, 1	; stdout, ekran
    mov ecx, girisMesaji
    mov edx, girisMesajUzunlugu
    int 80h		; kernel call

; Klavyeden girileni oku ve depola
    mov eax, 3	; sys_read
    mov ebx, 2	; stdin, klavye
    mov ecx, sayi
    mov edx, 5	; 5 bytes (4 sayý, 1 -+ iþareti için)
    int 80h

; Sayý çýkýþ mesajýný yansýt
    mov eax, 4
    mov ebx, 1
    mov ecx, cikisMesaji
    mov edx, cikisMesajUzunlugu
    int 80h

; Girilip depolanan sayýyý yansýt
    mov eax, 4
    mov ebx, 1
    mov ecx, sayi
    mov edx, 5
    int 80h

; Çýkýþ kodu
    mov eax, 1	; sys_exit
    mov ebx, 0
    int 80h