; nasm008.asm: Mesaj ve �oklu y�ld�zlar� altalta yazd�rma �rne�i.
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

    mov ecx, y�ld�zlar
    push ecx
    call _printf
    ;add esp, 4
    pop ecx
    ret

	section .data
mesaj: db "10 adet yanyana y�ld�z g�sterisi", 0xa
y�ld�zlar times 5 db "*"