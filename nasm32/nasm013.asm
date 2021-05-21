; nasm013.asm: Ekrana verilen mesajý yazdýran örnek.
;
; nasm -fwin32 nasm013.asm
; gcc -m32 nasm013.obj nasm013.c -o nasm013.exe
;------------------------------------------------------------------------------------

	SEGMENT .data	; Ýlkdeðerli deðiþkenler bölümü (segment=section)
    mesaj: db "Ekrana istediðin mesajý yazdýrabilirsin", 10, 0	; Altsatýr/newline=0 sonlandýrýcýyý unutma

	SECTION .text	; Kodlama bölümü
    extern _printf		; win32
    global _ekrana_yaz	; win32

_ekrana_yaz:
    push mesaj		; Mesajý yýðýna koy
    call _printf		; Yazdýrma C rutinini çaðýr
    pop eax		; Yýðýný boþalt
    ret			; Çaðýran C rutinine dön