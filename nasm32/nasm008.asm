; nasm008.asm: Mesaj ve �oklu y�ld�zlar� altalta yazd�rma �rne�i.
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

    mov ecx, Y�ld�zlar
    push ecx
    call _printf
    ;add esp, 4
    pop ecx
    ret

	section .data
Mesaj: db "10 adet yanyana y�ld�z g�sterisi:", 0xa
Y�ld�zlar times 5 db "*"