; tut09.asm: Klavyeden girilen 2 say�n�n toplam�n� yazd�rma �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Bir say� girin: 3
; Bir say� daha girin: 5
; Toplamlar�: 8
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===AR�TMET�K KOMUTLAR===
; Say�sal sabitler i�in kullan�lan EQU (k���k/b�y�k-harfe duyars�z) sabitleri program i�inde de�i�tirilemezken
; %assign (k���k harfle yaz�lmal�d�r) tahsisleri de�i�tirilebilir.
; %assign TOPLAM 10
; %assign TOPLAM 20	; sonradan de�i�tirildi
;
; %define, C'deki #define gibidir (harf duyarl�), say�sal ve dizgesel sabitler i�in kullan�l�r, sonradan de�i�tirilebilir.
; %define ��ARET�� [EBP+4]	; ebp+4 adresndeki de�er sabite kopyalan�r
;
; INC/Inrement/Birart�r, DEC/Decrement/Birazalt hedef (hedef -8,16, 32 bitli- kay�t�� yada bellek adresi/de�i�keni)
; INC EBX	; ebx +=1 (32-bit temel kay�t��)
; INC DL		; dl +=1 (8-bit kay�t��)
; INC [saya�]	; saya� +=1
;
; segment .data
; saya� dw 0
; de�er db 15
; segment .text
; inc [saya�]
; dec [de�er]
; mov ebx, saya�
; inc word [ebx]
; mov esi, de�er
; dec byte [esi]
;
; ADD/Add/Topla, SUB/Subtract/��kar hedef, kaynak (6-16, 32 bitli) kay�t��, bellek, de�i�kenler aras�ndad�r.
;----------------------------------------------------------------------------------------------------------------------------------------------

    �IK equ 1
    OKU equ 3
    YAZ equ 4
    KLAVYE equ 0
    EKRAN equ 1

	segment .data
    Mesaj1 db "Bir say� girin: ", 0xA, 0xD
    Uzunluk1 equ $ - Mesaj1
    Mesaj2 db "Bir say� daha girin: ", 0xA, 0xD
    Uzunluk2 equ $- Mesaj2
    Mesaj3 db "Toplamlar�: "
    Uzunluk3 equ $- Mesaj3

	segment .bss
    say�1 resb 2
    say�2 resb 2
    sonu� resb 1

	section .text
    global _start
_start:
    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, Mesaj1
    mov edx, Uzunluk1
    int 0x80

    mov eax, OKU
    mov ebx, KLAVYE
    mov ecx, say�1
    mov edx, 2
    int 0x80

    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, Mesaj2
    mov edx, Uzunluk2
    int 0x80

    mov eax, OKU
    mov ebx, KLAVYE
    mov ecx, say�2
    mov edx, 2
    int 0x80

    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, Mesaj3
    mov edx, Uzunluk3
    int 0x80

    mov eax, [say�1]
    sub eax, "0"	; ascii'yi ondal��a �evirir
    mov ebx, [say�2]
    sub ebx, "0"	; ascii'yi ondal��a �evirir
    add eax, ebx	; eax += ebx
    add eax, "0"	; ondal��� ascii'ye �evirir
    mov [sonu�], eax

    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, sonu�
    mov edx, 1
    int 0x80

��k��:
    mov eax, �IK
    xor ebx, ebx	; ebx=0
    int 0x80