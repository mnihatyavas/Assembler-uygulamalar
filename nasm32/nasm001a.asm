; nasm001a.asm: Merhaba d�nya mesaj�n�n dos penceresinden yans�t�lmas� �rne�i.
; ----------------------------------------------------------------------------
    global _main
    extern _printf ; C _printf fonksiyonunu �a��r�r...

    section .text
_main:
    push mesaj
    call _printf
    add esp, 4
    ret ; return
mesaj:
    db "Merhaba, Assembler D�nyas�!", 10, 0
; ----------------------------------------------------------------------------
; nasm -fwin32 nasm001.asm
; gcc -m32 nasm001.obj -o nasm001.exe