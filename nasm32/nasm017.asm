; -----------------------------------------------------------------------------------------------------------------
; nasm017.asm: 16 haneli 2 hex say�n�n toplam�n� yans�tma �rne�i.
;
; 80008FFF0005FEF2 + 800020E07FFE99AA = 8000B0DF7FFF989C
;
; nasm -fwin32 nasm017.asm
; gcc -m32 nasm017.obj
; a
; -----------------------------------------------------------------------------------------------------------------

    extern _printf
    global _main

	section .text
_main:
    movq mm0, [x]
    paddsw mm0, [y]
    movq [x], mm0

    push dword [x]
    push dword [x+4]
    push bi�imle
    call _printf
    add esp, 12
    ret

	section .data
    x dw 0fef2h, 0005h, 8fffh, 8000h
    y dw 099aah, 7ffeh, 20e0h, 8000h
    bi�imle db "80008FFF0005FEF2 + 800020E07FFE99AA =  %0x%0x", 10, 0