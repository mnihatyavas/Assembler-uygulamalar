; nasm001a.asm: Merhaba dünya mesajýnýn dos penceresinden yansýtýlmasý örneði.
; ----------------------------------------------------------------------------
    global _main
    extern _printf ; C _printf fonksiyonunu çaðýrýr...

    section .text
_main:
    push mesaj
    call _printf
    add esp, 4
    ret ; return
mesaj:
    db "Merhaba, Assembler Dünyasý!", 10, 0
; ----------------------------------------------------------------------------
; nasm -fwin32 nasm001.asm
; gcc -m32 nasm001.obj -o nasm001.exe