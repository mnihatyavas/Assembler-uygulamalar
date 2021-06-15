; asmtutor09.asm: Klavyeden girileni ekrandan yans�tma �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; L�tfen ad�n�z� girin: M.Nihat Yava�
; Merhaba Say�n: M.Nihat Yava�
;----------------------------------------------------------------------------------------------------------------------------------
; ===9.BSS �lkde�ersiz De�i�kenler B�l�m�===
; BSS: BlockStartedbySymbol/SembollerleBa�lat�lanBlok. �lk de�ersiz de�i�ken adlar� tan�m�nda kullan�l�r.
; SECTION .bss
; de�i�kenAd�1: RESB 1	; REServeByte 1 (1 byte tahsisi)
; de�i�kenAd�2: RESW 1	; REServeWord 1 (2 byte tahsisi)
; de�i�kenAd�3: RESD 1	; REServeDoubleword 1 (4 byte tahsisi)
; de�i�kenAd�4: RESQ 1	; REServeQuadword 1 (8 byte tahsisi)
; de�i�kenAd�5: REST 1	; REServeTenbytes 1 (10 byte tahsisi)
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj1 db "L�tfen ad�n�z� girin: ", 0h
    Mesaj2 db "Merhaba Say�n: ", 0h

	SECTION .bss
    veri_gir: resb 255	; Veri giri�i i�in azami 255 byte tahsisi

	SECTION .text
    global _start
_start:
    mov eax, Mesaj1
    call dyaz	; Altsat�rs�z mesaj yans�tma
    mov edx, 255	; Uzunluk
    mov ecx, veri_gir	; Girilecek veri adresi
    mov ebx, 0	; 0=Klavye (STDIN dosyas�)
    mov eax, 3	; 3=Oku (SYS_READ)
    int 80h

    mov eax, Mesaj2
    call dyaz	; Altsat�rs�z yaz
    mov eax, veri_gir	; Girilen veri arg�man�
    call dyaz	; Ayn� sat�r sonuna girileni yaz
    call son