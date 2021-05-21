; nasm001a.asm: Merhaba dünya mesajýnýn dos penceresinden yansýtýlmasý örneði.
;
; nasm -fwin32 nasm001.asm
; gcc -m32 nasm001.obj -o nasm001.exe
; gcc -m32 nasm001.obj	; ile a.exe yaratýlýr
; ----------------------------------------------------------------------------
    global _main
    extern _printf	; C printf fonksiyonunu çaðýrýr...

	section .data
    Mesaj db "Merhaba, Assembler Dünyasý!", 10, 0

	section .text
_main:
    push Mesaj
    call _printf
    add esp, 4
    ret	; return

