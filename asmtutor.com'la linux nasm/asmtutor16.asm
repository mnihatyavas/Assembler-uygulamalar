; asmtutor16.asm:  Klavyeden girilen �oklu tamsay�lar�n toplamlar� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; prog 20 1000 317
; Klavyeden girilen �oklu tamsay� arg�manlar�n toplam�: 1337
; NOT: �evrimi�i Nasm Assembler servislerden hi�biri include/klavyeGiri�i/komutSat�rl�Arg�manlar olmad���ndan,
; yada sonu� prog.exe'yi sana sunmad�klar�ndan, exe'si ile arg�manlar�n testi yap�lamamaktad�r.
;----------------------------------------------------------------------------------------------------------------------------------
; ===16.�oklu Klavye Arg�man�n Toplam�===
; Klavyeden girilen �oklu arg�man say�s� POP ECX sayac�na, program�n kendisiyse icab�nda POP EDX'le
; y���ndan al�nabilir. Sonraki ECX saya� adedince yap�lan POP EAX'lar herbir klavye giri� arg�man�n� y���ndan al�r.
; Klavye giri�leri dizgesel olup ascii tablo kar��l�klar�n� tamsay�ya (atoi: ascii to integer) �evirip (tamsay� de�ilse
; 0=s�f�r farzedip) bu tamsay�lar� toplar ve sonucu ekrana yans�t�r�z.
; �ok haneli rakamlarda herbir hane (ascii48-57) 10 ile �arp�larak �ncekiyle toplanmal�, son hanedeki fazlal�k
; �arp�msa DIV 10 ile geri al�nmal�d�r. Ayr�ca arg�man s�f�rsa 10'lu �arp�m ve b�l�m olmayacakt�r.
; �nce functions.asm=asmtutor05x.asm INCLUDE harici dosyaya atoi=adant (AsciiDanTamsay�ya) altrutini
; ilave etmeliyiz.
; ��lemlerde sadece 0-9/ascii48-57 tek btye kullan�ld���ndan fuzuli 32-bitlik EBX, yada 16-bitlik BX de�il, sadece
; 8-bit=1byte'l�k BL (BH de�il) kullan�lacakt�r.
; Toplam arg�man sayac� olarak ECX, tek arg�mandaki tamsay� rakam adedi d�ng� devam kontrol� i�inse ilk ascii48
; k�����ne yada ascii57 b�y���ne rastlama �art� kullan�l�r ve burada ECX sayac� s�f�rdan farkl�ysa son de�erin
; 10 ile b�l�m� yap�l�r (ECX=0 de�ilse 10'a b�l�nmez).
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "Klavyeden girilen �oklu tamsay� arg�manlar�n toplam�: ", 0h

	SECTION .text
    global _start
_start:
    pop ecx		; Klavyeden girilen arg�man say�s� (program ad� dahil)
    pop edx	; Arg�man 0 (program ad�)
    sub ecx, 1	; Program ad� saya�tan d���l�r
    mov edx, 0	; Arg�manlar�n toplam� kay�t��s�
birsonraki_arguman:
    cmp ecx, 0h
    jz argumanlar_bitti ; ECX=0 ise arg�manlar bitmi�tir, sonland�r
    pop eax	; Klavyeden girilen akt�el arg�man� y���ndan al
    call adant	; AsciiDanTamsay�ya fonksiyonunu �a��r�p, akt�el arg�man� tamsay�ya �evir
    add edx, eax	; EDX +=EAX (Akt�el tamsay� arg�man� genele topla)
    dec ecx		; S�f�r kontrolu i�in arg�man sayac�n� bir d���r
    jmp birsonraki_arguman
argumanlar_bitti:
    mov eax, Mesaj
    call dyaz
    mov eax, edx	; Genel toplam ekrana yazd�r�lacak
    call tyazAS
    call son