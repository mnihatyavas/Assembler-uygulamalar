; asmtutor08.asm: Altrutin çaðýrma esnasýnda geçirilen argümanlarýn kontrolu örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Mesaj yazdýrýrken geçirilen argümanlarýn testi.
; 
./jdoodle
;----------------------------------------------------------------------------------------------------------------------------------
; ===8.Argümanlar Geçirme===
; Altprograma kaç argüman geçirilmiþse ECX sayacý bunu kaydeder (ilk geçen fonksiyon adý, ikincisiyse argüman sayýsý).
; Yýðýndan ECX'i alýp, sýfýrlanýncaya dek döngüyle EAX'ý pop'layarak geçen argümanlarý yansýtabiliriz.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "Mesaj yazdýrýrken geçirilen argümanlarýn testi.", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj
    call dyazAS
    pop ecx		; LIFO yýðýn üstündeki ilk deðer geçirilen argüman sayýsýdýr
birsonraki_arguman:
    cmp ecx, 0h	; Baþka argüman kaldý mý kontrolu
    jz sonn
    pop eax	; Yýðýna konulan argüman deðerini al
    call dyazAS	; Argüman deðerini yanssýt
    dec ecx		; Argüman sayýsýsý sayacýný bir düþür
    jmp birsonraki_arguman

sonn:
    call son