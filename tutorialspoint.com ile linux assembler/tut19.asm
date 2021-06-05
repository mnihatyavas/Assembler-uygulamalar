; tut19.asm: On elemanl� dizi say�lar�n�n toplam�n� g�sterme �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 5
;----------------------------------------------------------------------------------------------------------------------------------------------
; ==== D�ZGELER ====
; De�i�ken uzunluktaki dizgeleri assembler'da tespit i�in, uzunluk alenen yaz�labilir:
; Mesaj db "Merhaba, d�nya!", 0xa
; Uzunluk equ 15 ; dizgemizin sayabilece�iniz krk say�s�
;
; $ sembol�yle otomatikmen tespit:
; Mesaj db "Merhaba, d�nta!", 0xa
; Uzunluk equ $ - Mesaj
; 
; Yada sabite sonuna konulan s�f�r dizge sonunun g�zc�s�d�r:
; Mesaj db "Merhaba, d�nta!", 0xa, 0
;
; komut kaynak, hedef ; kaynak 32-bit i�in ESI, 16-bit i�in SI/SourceIndex; hedef 32-bit i�in EDI, 16-bit i�in DI/DestinationIndex
TemelKomutlar ��lemciler         Byte��lem  Word��lem  DW��lem
MOVS                ES:DI, DS:SI  MOVSB     MOVSW      MOVSD	; MoveString, ExtraSegment:DestinationIndex, DataSegment:SourceIndex; Ta��
LODS                 AX, DS:SI       LODSB      LODSW       LODSD	; LoadString; Bellekten (toplay�c�) kay�t��ya oku
STOS                 ES:DI, AX        STOSB      STOSW       STOSD	; StoreString; Kay�t��dan belle�e yaz
CMPS                 DS:SI, ES:DI  CMPSB      CMPSW       CMPSD	; CompareString; Bellekteki kaynakla hedefi k�yasla
SCAS                 ES:DI, AX        SCASB      SCASW       SCASD	; SourceCompareAccumulatorString; Bellekkteki hedefle kay�t��y� k�yasla
;
; REP MOVSB ; Repeat ile CX saya� s�f�rlan�ncaya kez tekrarla
; REPE veya REPZ, ZF=1 ise veya CX=0 de�ilse tekrarla
; REPNE veya REPNZ, ZF=0 ise veya CX=0 de�ilse tekrarla
; CLD ; ClearDirection, DF=0 ve dizge �zerindeki i�lem soldan sa�a
; STD , SetDirection, DF=1 ve i�lem sa�dan sola
;
; ==== D�Z�LER ====
; Diziler ilk adresi ve artan byte takibiyle kurulur, normalde tek de�i�kenden fark� yoktur.
; AYLAR1 DW 12	; DataWord, kelime=2 byte
; AYLAR2 DW 0CH
; AYLAR3 DW 1100B
; Her ��de�i�ken de ayn�d�r, ayn� de�eri ta��rlar.
; SAYILAR DW 34, 45, 56, 67, 75, 89	; bellekte 2*6=12 ard���k byte yeri kaplarlar: SAYILAR, SAYILAR+2,.. SAYILAR+10
;
; A�a��daki her�� yaz�l�m da ayn� ge�erliliktedir:
; ENVANTER DW 0
; ENVANTER DW 0
; ...
; ENVANTER DW 0		; Toplam 8 adet
; ENVANTER DW 0, 0, 0, 0, 0, 0, 0, 0
; ENVANTER TIMES 8 DW 0
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov eax, 10	; toplanacak dizi eleman say�s�
    mov ebx, 0	; EBX toplam� sonu�land�r�ncaya dektutacak
    mov ecx, dizi	; ECX dizi'nin ilk adresini i�aret edecek
�st:
    add ebx, [ecx]	; ebx +=ecx: akt�el ECX de�erini EBX'e ekle
    add ecx,1	; birsonraki byte'� i�aret et
    dec eax		; eax -=1:saya� olarak kulln�lan EAX'� bir d���r
    jnz �st		; dec eax sonucu ZF=1 de�ilse �st'e atla
bitti:
    add ebx, "0"	; ascii'ye �evir
    mov [toplam], ebx	; EBX sonucu toplam'a aktar
g�ster:
    mov edx,1	; toplam'�n uzunlu�u db=1 byte
    mov ecx, toplam	; yazd�r�lacak toplam
    mov ebx, 1	; 1=ekran
    mov eax, 4	; 4=yaz
    int 0x80

    mov eax, 1	; 1=��k
    int 0x80

	section .data
    global dizi
    dizi: db 2, 0, 3, 0, 0, 0, 2, 0, 0, -2
    toplam: db 0