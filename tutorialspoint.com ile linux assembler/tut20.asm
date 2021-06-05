; tut20.asm: �ki say�y� toplay�p d�nd�ren altrutin �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 4 + 5 = 9
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===ALTRUT�N===
; Call ile �a�r�lan metotlar (prosed�r/i�lem/rutin/fonksiyon/altprogram):
; Altrutinler isimle ba�lar, kodlamayla devam eder ve RET/return ile sonbulur. Altrutin ba�ka programdan CALL
; ile ismiyle �a�r�l�r.
; ECX ve EDX'deki de�erleri toplayarak EAX ile geri d�nd�ren bir altrutin �rrne�i g�relim.
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov ecx, "4"
    sub ecx, "0"	; ascii'den ondal��a
    mov edx, "5"
    sub edx, "0"	; ascii'den ondal��a
    call toplam	; toplam altrutini �a��r
    mov [sonu�], eax	; sonu�=eax

    mov ecx, Mesaj
    mov edx, Uzunluk
    mov ebx, 1	; 1=ekran
    mov eax, 4	; 4=yaz
    int 0x80		; kernel'i �a��r

    mov ecx, sonu�
    mov edx, 1
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov eax,1	; 1=��k
    int 0x80

toplam:
    mov eax, ecx	; eax=ecx
    add eax, edx	; eax +=dex
    add eax, "0"	; ondal�ktan ascii'ye
    ret		; �a��rana d�n

	section .data
    Mesaj db "4 + 5 = ", 0xA, 0xD	; 0xD: sonraki yazma ayn� sat�ra
    Uzunluk equ $- Mesaj

	segment .bss
    sonu� resb 1