; nasm001c.asm: Tutorialspoint.com ile merhaba �rne�i.
;
; nasm -fwin32 nasm001c.asm
; gcc -m32 nasm001c.obj
;------------------------------------------------------------------------------------------------

    global _main	; gcc ba�lay�c�/ld i�in tan�mlanmal�
    extern _printf	; yazd�rma C fonksiyonu

	segment .text	; section .text
_main:		; ba�lay�c�/linker ba�lang�� noktas�
    push Mesaj	; data b�l�m�nden mesaj dizgesini y���na koy
    call _printf	; mesaj� ekrana yazd�r
    add esp, 4	; g�stergeyi 4 bit ileri al

    ret		; gerid�n/sonland�r

	segment .data	; section .data
    Mesaj db "Merhaba, nasm32 d�nyas�!..", 10, 0