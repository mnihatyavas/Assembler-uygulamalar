; asmtutor06.asm: Mesaj sonlar�na ascii 0/null byte'�n�n eklenmesi �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Dizge sonuna ascii 0/null sonland�r�c� byte ekli ilk mesaj.
; 
Dizge sonuna ascii 0/null sonland�r�c� byte ekli ikinci mesaj.
;----------------------------------------------------------------------------------------------------------------------------------
; ===6.Hi� Sonland�r�c� Byte===
; Altrutinde mesaj uzunlu�u kar��la�t�rmas� null/hi� ascii 0 ile yap�ld���ndan, bunun mesaj sonuna 0H ile
; eklenmesi muhtemel hatalar� �nler.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj1 db "Dizge sonuna ascii 0/null sonland�r�c� byte ekli ilk mesaj.", 0Ah, 0h
    Mesaj2 db "Dizge sonuna ascii 0/null sonland�r�c� byte ekli ikinci mesaj.", 0Ah, 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj1
    call dyaz	; yaz altrutini �nce uzunluk altrutinini �a��r�r/d�ner
    mov eax, Mesaj2
    call dyaz	; DizgeYAZ
    call son