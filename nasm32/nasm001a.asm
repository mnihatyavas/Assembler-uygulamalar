; nasm001a.asm: Merhaba d�nya mesaj�n�n dos penceresinden yans�t�lmas� �rne�i.
;
; nasm -fwin32 nasm001.asm
; gcc -m32 nasm001.obj -o nasm001.exe
; gcc -m32 nasm001.obj	; ile a.exe yarat�l�r
; ----------------------------------------------------------------------------
    global _main
    extern _printf	; C printf fonksiyonunu �a��r�r...

	section .data
    Mesaj db "Merhaba, Assembler D�nyas�!", 10, 0

	section .text
_main:
    push Mesaj
    call _printf
    add esp, 4
    ret	; return

