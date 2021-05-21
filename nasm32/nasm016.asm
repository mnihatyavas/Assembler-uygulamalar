; ------------------------------------------------------------------------------------------------------------------
; nasm016.asm: Veri k�sm�ndan girilen ondal�k say�lar�n ��kt�s�n� yans�tma �rne�i.
;
; nasm -fwin32 nasm016.asm
; gcc -m32 nasm016.obj
; a
; ------------------------------------------------------------------------------------------------------------------

    extern _printf
    global _main

	section .text
_main:
    push esi
    movups xmm3, [x]
    sqrtps xmm0, xmm3
    movups [y], xmm0
    call hepsini_yaz

    movups xmm2, [x]
    movups xmm5, [z]
    maxps xmm2, xmm5
    movups [y], xmm2
    call hepsini_yaz

    pop esi
    ret

hepsini_yaz:
    mov esi, 4
birini_yaz:
    fld dword [y-4+esi*4]
    sub esp, 8
    fstp qword [esp]
    push bi�imle
    call _printf
    add esp, 12
    dec esi
    jnz birini_yaz
    ret

	section .data
    x dd 10.0
    dd 100.0
    dd 400.0
    dd 653.2664
    y dd 0.0
    dd 0.0
    dd 0.0
    dd 0.0
    z dd 5.0
    dd 900.0
    dd 316.20
    dd 111.0
    bi�imle db "%15.7f", 10, 0