; asmtutor17.asm: Yerel ve global etiket adlar� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Atlayan altrutin no: 1

; Enyak�n �oklu lokal '.bitir:' etiketine atlad�.
; 
Atlayan altrutin no: 2
; 
Enyak�n �oklu lokal '.bitir:' etiketine atlad�.
; 
Atlayan altrutin no: 3
; 
Global tikel 'bitir:' etiketine atlad�.
;----------------------------------------------------------------------------------------------------------------------------------
; ===17.Yerel/Global Etiketadlar�===
; .etiket_ad� �eklinde �nlerinde . bulunan etiketadlar� ayn� program i�inde birden fazla yerde tan�mlanabilir, fakat
; JMP .etiket_ad� kendisine enyak�n lokal paragrafa atlar. �nlerinde nokta olmayan etiket_ad� ise globaldir ve
; programda sadece bir yerde kullan�lmal�d�r.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj1 db "Enyak�n �oklu lokal '.bitir:' etiketine atlad�.", 0h
    Mesaj2 db "Atlayan altrutin no: ", 0h
    Mesaj3 db "Global tikel 'bitir:' etiketine atlad�.", 0h

	SECTION .text
    global _start
_start:
altrutin_bir:
    mov eax, Mesaj2
    call dyaz
    mov eax, 1
    call tyazAS
    jmp .bitir	; enyak�n (�oklu) lokal (hemen takipeden) .bitti'ye atlar
.bitir:
    mov eax, Mesaj1
    call dyazAS
altrutin_iki:
    mov eax, Mesaj2
    call dyaz
    mov eax, 2
    call tyazAS
    jmp .bitir	; enyak�n (�oklu) lokal (hemen takipeden) .bitti'ye atlar
.bitir:
    mov eax, Mesaj1
    call dyazAS
altrutin_��:
    mov eax, Mesaj2
    call dyaz
    mov eax, 3
    call tyazAS
    jmp bitir	; (Tikel) global bitti'ye atlar
bitir:
    mov eax, Mesaj3
    call dyazAS

    call son