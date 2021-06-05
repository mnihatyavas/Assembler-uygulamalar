; tut20.asm: Ýki sayýyý toplayýp döndüren altrutin örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 4 + 5 = 9
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===ALTRUTÝN===
; Call ile çaðrýlan metotlar (prosedür/iþlem/rutin/fonksiyon/altprogram):
; Altrutinler isimle baþlar, kodlamayla devam eder ve RET/return ile sonbulur. Altrutin baþka programdan CALL
; ile ismiyle çaðrýlýr.
; ECX ve EDX'deki deðerleri toplayarak EAX ile geri döndüren bir altrutin örrneði görelim.
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov ecx, "4"
    sub ecx, "0"	; ascii'den ondalýða
    mov edx, "5"
    sub edx, "0"	; ascii'den ondalýða
    call toplam	; toplam altrutini çaðýr
    mov [sonuç], eax	; sonuç=eax

    mov ecx, Mesaj
    mov edx, Uzunluk
    mov ebx, 1	; 1=ekran
    mov eax, 4	; 4=yaz
    int 0x80		; kernel'i çaðýr

    mov ecx, sonuç
    mov edx, 1
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov eax,1	; 1=çýk
    int 0x80

toplam:
    mov eax, ecx	; eax=ecx
    add eax, edx	; eax +=dex
    add eax, "0"	; ondalýktan ascii'ye
    ret		; çaðýrana dön

	section .data
    Mesaj db "4 + 5 = ", 0xA, 0xD	; 0xD: sonraki yazma ayný satýra
    Uzunluk equ $- Mesaj

	segment .bss
    sonuç resb 1