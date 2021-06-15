; asmtutor07.asm: Altsat�rs�z ve altsat�rl� yaz/yazAS altrutinleri kullanma �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Sonu sadece ascii 0/null ile biten ilk mesaj!

; Sonu sadece ascii 0/null ile biten ikinci mesaj!
;----------------------------------------------------------------------------------------------------------------------------------
; ===7.Altsat�ra Ge�i�===
; Mesaj sonundaki ascii 0/null=0H mesaj uzunlu�u kar��la�t�rmas�nda gerekliyken, ascii 10/LF=0AH de
; mesaj yaz�ld�ktan sonra biralt/LineFeed sat�ra ge�i� i�in gereklidir. Ancak programc� bazen altsat�ra ge�mek
; ister bazzen de istemez. Bu itibarla 0AH her mesaj sonuna de�il, ayr� bir altrutin olarak yaz�l�rsa, istenildi�inde
; alt sat�ra atlanabilir. asmtutor05x.asm harici altrutinler dosyas�n�n buna g�re g�ncellenmesi gerekir.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj1 db "Sonu sadece ascii 0/null ile biten ilk mesaj!", 0h
    Mesaj2 db "Sonu sadece ascii 0/null ile biten ikinci mesaj!", 0h

	SECTION .text
global _start
_start:
    mov eax, Mesaj1
    call dyazAS	; Mesaj1 yaz�l�r ve altsat�ra ge�ilir
    mov eax, Mesaj2
    call dyazAS	; DizgeYazAltSat�r
    call son