; asmtutor10.asm: Rakam�n ascii tablo karakter kar��l���n� yazd�rma �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 0
; 
1
; 2
; 
3

; 4

; 5

; 6

; 7

; 8

; 9
; 
:
;----------------------------------------------------------------------------------------------------------------------------------
; ===10.ASCII Tablosu===
; ASCII: AmericanStandardCodeforInformationInterchange/BilgiDe�i�toku�ui�inAmerikaStandartKodlamas�.
; ��kt�ya yazd�r�lan her�ey ASCII tablo karakterlerine uymal�d�r. Say�sal [0,9]=ascii [48,57]'ye denk d��er.
; ECX sayac� 0-->10 sayarken, yazd�rma altrutinine ilgili rakam�n ascii tablo karakter kar��l���n� bildirmeliyiz.
; Saya�la 10 yazd�rmak isterken (:)=ascii58 yazd�!?..
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .text
    global _start
_start:
    mov ecx, 0	; saya� ilkde�eri=0
birsonraki_rakam:
    mov eax, ecx	; EAX=ECX saya� de�eri
    add eax, 48	; EAX +=48 (0=ascii48)
    push eax	; yaz �ncesi y���na sakla
    mov eax, esp	; Y���n g�sterge adresini (ascii rakam�) EAX kay�t��ya ta��
    call dyazAS
    pop eax	; Y���ndaki son konulan� sil
    inc ecx		; ECX sayac� birart�r
    cmp ecx, 11	; Saya� 10 ise d�ng�y� sonland�r
    jne birsonraki_rakam
    call son