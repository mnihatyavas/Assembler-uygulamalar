; tut01.asm: Merhaba linux nasm assemler �rne�i.
;
; $nasm -f elf *.asm
; ld -m elf_i386 -s -o demo *.o
; $demo
; Merhaba, �evrimi�i linux nasm assembler d�nyas�!
;--------------------------------------------------------------------------------------------------------------------------
; ===TEMEL D�Z�L�M===
; Assembler bilgisayar donan�mlar�ndan i�lemci, kay�t��lar ve belle�i kullanarak farkl� veri tiplerini
; i�ler: Byte (8bit), Word/Kelime (2 byte), Doubleword/�iftkelime (4 byte), Quadword/D�rtl�kelime
; (8 byte), Paragraf (16 byte), KB (1024 byte), MB (1,048,576 byte).
; 1byte=11111111=1+2+4+8+16+32+64+128=255=2^8-1
; 1 byte 8 bit yada 2 adet d�rderli bitli hex olarak okunabilir: 0=0=0, 1=1=1, 2=01=2, 3=11=3, 4=100=4,
; 5=101=5, 6=110=6, 7=111=7, 8=1000=8, 9=1001=9, 10=1010=A, 11=1011=B, 12=1100=C, 13=1101=D,
; 14=1110=E, 15=1111=F. Hex onalt�l� b�y�k/k���k harf farketmez.
; �kili 1000 1100 1101 0001=8CD1 hex, Hex FAD8=1111 1010 1101 1000 ikili
; Ondal�k 60+42=102 ise ikili 00111100 + 00101010 = 01100110
; Say�n�n negatifi, pozitif ikilinin tamlay�c�s� + 1'dir. +53=00110101, tamlay�c�s�=11001010 +1=11001011=-53
; Ondal�k ��karma 53-42=11 ise ikili +42=00101010, -42=11010101+1=11010110, 53+(-42)=00001011 ve
; ta�an 1 kaybolur.
;
; Komutlar haf�zadan getirilir, ��z�mlenir, i�lenir. bellekten al�nan 2507H kelime, kay�t��ya tersten konur.
; �lk al�nan d���k byte'a, ikincisi y�ksek byte'a aktar�l�r.
; Bellek adresi ya mutlakt�r, yada ba�lang��+telafi adreslidir.
; 
; Bu kursta NASM/NetwideAssembler assembler ve �evrimi�i Linux i�letim sistemi kullan�lacakt�r, �rnek assembler
; kodlar� �evrimi�i www.tutorialspoint.com'un mevcut Linuz sistemine kopyalan�p �al��t�r�lacakt�r.
;
; Bir assembler program� 3 b�l�ml�d�r: section/segment data (ilk de�erli sabitler), bss (de�i�kenler), text (kodlama).
; section .text
;     global _start
; _start:
;
; Yorumlar kodlu/kodsuz sat�rda ; ile ba�larlar.
; add eax, ebx	; eax += ebx
;
Bir assembler ifadesinin genel yaz�l�m�: [etiket] komut [parametreler] [; yorum]
; ��lemci komutu mecburi, di�erleri tercihidir. Birka� �rnek:
; INC SAYA� ; SAYA� += 1
; MOV TOPLAM, 48 ; TAPLAM = 48
; ADD AH, BH ; AH += BH
; AND DE���KEN1, 128 ; Bellek DE���KEN i�eri�ini 128'le AND'le
; ADD DE��KEN2, 10 ; DE���KEN2 += 10
; MOV AL, 10 ; AL = 10
;--------------------------------------------------------------------------------------------------------------------------

	section .data
    Mesaj db "Merhaba, �evrimi�i linux nasm assembler d�nyas�!", 0xa	; =10: yazd�r�lacak dizge
    Uzunluk equ $ - Mesaj	; Mesaj dizgesinin uzunlu�u

    global _start	; ba�lay�c�/linker=ld i�in beyan� mecburidir
	section .text
_start:	; kodlamaya ilk giri� noktas�
    mov edx, Uzunluk		; Mesaj uzunlu�u, EDX/DataRegister/VeriKay�t��
    mov ecx, Mesaj		; Yazd�r�lacak Mesaj, ECX/CounterRegister/Saya�Kay�t��
    mov ebx,1		; Yazd�r�lacak dosya no=1 (stdout/standart-��kt�), EBX/BaseRegister/TemelKay�t��
    mov eax, 4		; Sistem call/�a��r no=4 (sys_write/yaz), EAX/AccumulatorRegister/Toplay�c�Kay�t��
    int 0x80			; Kernel'i yazd�rma i�in call/�a��r
    mov eax,1		; Sistem �a��r no=1 (sys_exit/��k)
    int 0x80			; Kernell'i ��k�� i�in �a��r
