; tut21.asm: Ascii 256 karakterleri ard���k �ekilde altrutine yazd�rma �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===ALTRUT�N ve YI�IN VER� YAPISI===
; Y���n bellekte dizin benzeri veri saklamakta kullan�lan PUSH ile konulan, POP ile al�nan LIFO/LastInFirtOut
; tepeden i�leyen yap�d�r. Y���n akt�el tepe adresini SS:SP (StackSegment:StackPointer) yada SS:ESP g�sterir.
; Y���na kelime yada dw konur, byte de�il; bellekte adres tepeden alta azal�r; y���n tepe adresi son konulan kelimenin
; al�ak byte'�d�r. Koyma ve alma komutlar�:
; AX ve BX kay�t�� de�erleri y���na konulacak
; PUSH AX
; PUSH BX
; Art�k bu kay�t��lar ba�ka ama�larla kullan�labilir
; MOV AX, DE�ER1
; MOV BX, DE�ER2
; MOV DE�ER3, AX
; MOV DE�ER4, BX
; Orijinal de�erleri y���ndan alal�m
; POP BX
; POP AX
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    call g�ster	; altrutin �a�r�l�r, ret ile gerid�n�l�r
    mov eax,1	; 1=��k
    int 0x80

g�ster:
    mov ecx, 256	; saya�, ascii karakter say�s�
birsonraki_karakter:
    push ecx	; akt�el d�ng� say�s�n� y���na koy
    mov eax, 4
    mov ebx, 1
    mov ecx, Karakter	; ilkanda ascii "0" yaz�lacak
    mov edx, 1
    int 80h

    pop ecx		; y���ndan akt�el d�ng� say�s�n� geri al
    ;mov dx, [Karakter]
    ;cmp byte [Karakter], 0dh
    inc byte [Karakter]	; Ascii karakteri birart�r
    loop birsonraki_karakter	; saya� s�f�rlanmam��sa d�ng�ye devam
    ret

	section .data
    Karakter db "0"