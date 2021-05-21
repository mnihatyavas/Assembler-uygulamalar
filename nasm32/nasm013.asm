; nasm013.asm: Ekrana verilen mesaj� yazd�ran �rnek.
;
; nasm -fwin32 nasm013.asm
; gcc -m32 nasm013.obj nasm013.c -o nasm013.exe
;------------------------------------------------------------------------------------

	SEGMENT .data	; �lkde�erli de�i�kenler b�l�m� (segment=section)
    mesaj: db "Ekrana istedi�in mesaj� yazd�rabilirsin", 10, 0	; Altsat�r/newline=0 sonland�r�c�y� unutma

	SECTION .text	; Kodlama b�l�m�
    extern _printf		; win32
    global _ekrana_yaz	; win32

_ekrana_yaz:
    push mesaj		; Mesaj� y���na koy
    call _printf		; Yazd�rma C rutinini �a��r
    pop eax		; Y���n� bo�alt
    ret			; �a��ran C rutinine d�n