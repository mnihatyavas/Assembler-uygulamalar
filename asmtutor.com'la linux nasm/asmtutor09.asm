; asmtutor09.asm: Klavyeden girileni ekrandan yansýtma örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Lütfen adýnýzý girin: M.Nihat Yavaþ
; Merhaba Sayýn: M.Nihat Yavaþ
;----------------------------------------------------------------------------------------------------------------------------------
; ===9.BSS Ýlkdeðersiz Deðiþkenler Bölümü===
; BSS: BlockStartedbySymbol/SembollerleBaþlatýlanBlok. Ýlk deðersiz deðiþken adlarý tanýmýnda kullanýlýr.
; SECTION .bss
; deðiþkenAdý1: RESB 1	; REServeByte 1 (1 byte tahsisi)
; deðiþkenAdý2: RESW 1	; REServeWord 1 (2 byte tahsisi)
; deðiþkenAdý3: RESD 1	; REServeDoubleword 1 (4 byte tahsisi)
; deðiþkenAdý4: RESQ 1	; REServeQuadword 1 (8 byte tahsisi)
; deðiþkenAdý5: REST 1	; REServeTenbytes 1 (10 byte tahsisi)
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj1 db "Lütfen adýnýzý girin: ", 0h
    Mesaj2 db "Merhaba Sayýn: ", 0h

	SECTION .bss
    veri_gir: resb 255	; Veri giriþi için azami 255 byte tahsisi

	SECTION .text
    global _start
_start:
    mov eax, Mesaj1
    call dyaz	; Altsatýrsýz mesaj yansýtma
    mov edx, 255	; Uzunluk
    mov ecx, veri_gir	; Girilecek veri adresi
    mov ebx, 0	; 0=Klavye (STDIN dosyasý)
    mov eax, 3	; 3=Oku (SYS_READ)
    int 80h

    mov eax, Mesaj2
    call dyaz	; Altsatýrsýz yaz
    mov eax, veri_gir	; Girilen veri argümaný
    call dyaz	; Ayný satýr sonuna girileni yaz
    call son