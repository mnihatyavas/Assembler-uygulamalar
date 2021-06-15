; asmtutor10.asm: Rakamýn ascii tablo karakter karþýlýðýný yazdýrma örneði.
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
; ASCII: AmericanStandardCodeforInformationInterchange/BilgiDeðiþtokuþuiçinAmerikaStandartKodlamasý.
; Çýktýya yazdýrýlan herþey ASCII tablo karakterlerine uymalýdýr. Sayýsal [0,9]=ascii [48,57]'ye denk düþer.
; ECX sayacý 0-->10 sayarken, yazdýrma altrutinine ilgili rakamýn ascii tablo karakter karþýlýðýný bildirmeliyiz.
; Sayaçla 10 yazdýrmak isterken (:)=ascii58 yazdý!?..
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .text
    global _start
_start:
    mov ecx, 0	; sayaç ilkdeðeri=0
birsonraki_rakam:
    mov eax, ecx	; EAX=ECX sayaç deðeri
    add eax, 48	; EAX +=48 (0=ascii48)
    push eax	; yaz öncesi yýðýna sakla
    mov eax, esp	; Yýðýn gösterge adresini (ascii rakamý) EAX kayýtçýya taþý
    call dyazAS
    pop eax	; Yýðýndaki son konulaný sil
    inc ecx		; ECX sayacý birartýr
    cmp ecx, 11	; Sayaç 10 ise döngüyü sonlandýr
    jne birsonraki_rakam
    call son