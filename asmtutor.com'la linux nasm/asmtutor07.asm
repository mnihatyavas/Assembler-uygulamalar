; asmtutor07.asm: Altsatýrsýz ve altsatýrlý yaz/yazAS altrutinleri kullanma örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Sonu sadece ascii 0/null ile biten ilk mesaj!

; Sonu sadece ascii 0/null ile biten ikinci mesaj!
;----------------------------------------------------------------------------------------------------------------------------------
; ===7.Altsatýra Geçiþ===
; Mesaj sonundaki ascii 0/null=0H mesaj uzunluðu karþýlaþtýrmasýnda gerekliyken, ascii 10/LF=0AH de
; mesaj yazýldýktan sonra biralt/LineFeed satýra geçiþ için gereklidir. Ancak programcý bazen altsatýra geçmek
; ister bazzen de istemez. Bu itibarla 0AH her mesaj sonuna deðil, ayrý bir altrutin olarak yazýlýrsa, istenildiðinde
; alt satýra atlanabilir. asmtutor05x.asm harici altrutinler dosyasýnýn buna göre güncellenmesi gerekir.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj1 db "Sonu sadece ascii 0/null ile biten ilk mesaj!", 0h
    Mesaj2 db "Sonu sadece ascii 0/null ile biten ikinci mesaj!", 0h

	SECTION .text
global _start
_start:
    mov eax, Mesaj1
    call dyazAS	; Mesaj1 yazýlýr ve altsatýra geçilir
    mov eax, Mesaj2
    call dyazAS	; DizgeYazAltSatýr
    call son