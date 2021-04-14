; nasm008.asm: Mesaj ve çoklu yýldýzlarý altalta yazdýrma örneði.
;-----------------------------------------------------------------------------------------

    global _main
    extern _printf

	section .text
_main:
    mov ecx, mesaj
    push ecx
    call _printf
    ;add esp, 4
    pop ecx

    mov ecx, yýldýzlar
    push ecx
    call _printf
    ;add esp, 4
    pop ecx
    ret

	section .data
mesaj: db "10 adet yanyana yýldýz gösterisi", 0xa
yýldýzlar times 5 db "*"