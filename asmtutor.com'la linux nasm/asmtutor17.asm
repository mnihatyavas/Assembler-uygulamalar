; asmtutor17.asm: Yerel ve global etiket adlarý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Atlayan altrutin no: 1

; Enyakýn çoklu lokal '.bitir:' etiketine atladý.
; 
Atlayan altrutin no: 2
; 
Enyakýn çoklu lokal '.bitir:' etiketine atladý.
; 
Atlayan altrutin no: 3
; 
Global tikel 'bitir:' etiketine atladý.
;----------------------------------------------------------------------------------------------------------------------------------
; ===17.Yerel/Global Etiketadlarý===
; .etiket_adý þeklinde önlerinde . bulunan etiketadlarý ayný program içinde birden fazla yerde tanýmlanabilir, fakat
; JMP .etiket_adý kendisine enyakýn lokal paragrafa atlar. Önlerinde nokta olmayan etiket_adý ise globaldir ve
; programda sadece bir yerde kullanýlmalýdýr.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj1 db "Enyakýn çoklu lokal '.bitir:' etiketine atladý.", 0h
    Mesaj2 db "Atlayan altrutin no: ", 0h
    Mesaj3 db "Global tikel 'bitir:' etiketine atladý.", 0h

	SECTION .text
    global _start
_start:
altrutin_bir:
    mov eax, Mesaj2
    call dyaz
    mov eax, 1
    call tyazAS
    jmp .bitir	; enyakýn (çoklu) lokal (hemen takipeden) .bitti'ye atlar
.bitir:
    mov eax, Mesaj1
    call dyazAS
altrutin_iki:
    mov eax, Mesaj2
    call dyaz
    mov eax, 2
    call tyazAS
    jmp .bitir	; enyakýn (çoklu) lokal (hemen takipeden) .bitti'ye atlar
.bitir:
    mov eax, Mesaj1
    call dyazAS
altrutin_üç:
    mov eax, Mesaj2
    call dyaz
    mov eax, 3
    call tyazAS
    jmp bitir	; (Tikel) global bitti'ye atlar
bitir:
    mov eax, Mesaj3
    call dyazAS

    call son