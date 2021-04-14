; nasm001c.asm: tutorialspoint.com ile merhaba örneði.
;------------------------------------------------------------------------------------------------

    global _main	; gcc baðlayýcý/ld için tanýmlanmalý
    extern _printf	; yazdýrma C fonksiyonu

	segment .text	; section .text
_main:		; baðlayýcý/linker baþlangýç noktasý
    push mesaj	; data bölümünden mesaj dizgesini yýðýna koy
    call _printf	; mesajý ekrana yazdýr
    add esp, 4	; göstergeyi 4 bit ileri al

    ret		; geridön/sonlandýr

	segment .data	; section .data
mesaj db "Merhaba, nasm32 dünyasý!..", 10, 0