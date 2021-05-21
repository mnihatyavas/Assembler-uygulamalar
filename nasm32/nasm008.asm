; nasm008.asm: Mesaj ve çoklu yýldýzlarý altalta yazdýrma örneði.
;
; nasm -fwin32 nasm008.asm
; gcc -m32 nasm008.obj
;-----------------------------------------------------------------------------------------

    global _main
    extern _printf

	section .text
_main:
    mov ecx, Mesaj
    push ecx
    call _printf
    ;add esp, 4
    pop ecx

    mov ecx, Yýldýzlar
    push ecx
    call _printf
    ;add esp, 4
    pop ecx
    ret

	section .data
Mesaj: db "10 adet yanyana yýldýz gösterisi:", 0xa
Yýldýzlar times 5 db "*"