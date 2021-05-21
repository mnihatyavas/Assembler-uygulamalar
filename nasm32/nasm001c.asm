; nasm001c.asm: Tutorialspoint.com ile merhaba örneði.
;
; nasm -fwin32 nasm001c.asm
; gcc -m32 nasm001c.obj
;------------------------------------------------------------------------------------------------

    global _main	; gcc baðlayýcý/ld için tanýmlanmalý
    extern _printf	; yazdýrma C fonksiyonu

	segment .text	; section .text
_main:		; baðlayýcý/linker baþlangýç noktasý
    push Mesaj	; data bölümünden mesaj dizgesini yýðýna koy
    call _printf	; mesajý ekrana yazdýr
    add esp, 4	; göstergeyi 4 bit ileri al

    ret		; geridön/sonlandýr

	segment .data	; section .data
    Mesaj db "Merhaba, nasm32 dünyasý!..", 10, 0