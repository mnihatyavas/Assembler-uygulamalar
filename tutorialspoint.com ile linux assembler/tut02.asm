; tut02.asm: Bölüm adý section yada segment örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Tekrar merhaba, çevrimiçi linux nasm assembler dünyasý!
;--------------------------------------------------------------------------------------------------------------------------
; ===BELLEK BÖLÜMLERÝ===
; Bölüm adý için section yada segment kullanýlmasý farketmez.
;--------------------------------------------------------------------------------------------------------------------------

	segment .data
    Mesaj db "Tekrar merhaba, çevrimiçi linux nasm assembler dünyasý!", 0xa	; =10: yazdýrýlacak dizge
    Uzunluk equ $ - Mesaj	; Mesaj dizgesinin uzunluðu

    global _start	; baðlayýcý/linker=ld için beyaný mecburidir
	segment .text
_start:	; kodlamaya ilk giriþ noktasý
    mov edx, Uzunluk		; Mesaj uzunluðu, EDX/DataRegister/VeriKayýtçý
    mov ecx, Mesaj		; Yazdýrýlacak Mesaj, ECX/CounterRegister/SayaçKayýtçý
    mov ebx,1		; Yazdýrýlacak dosya no=1 (stdout/standart-çýktý), EBX/BaseRegister/TemelKayýtçý
    mov eax, 4		; Sistem call/çaðýr no=4 (sys_write/yaz), EAX/AccumulatorRegister/ToplayýcýKayýtçý
    int 0x80			; Kernel'i yazdýrma için call/çaðýr
    mov eax,1		; Sistem çaðýr no=1 (sys_exit/çýk)
    int 0x80			; Kernell'i çýkýþ için çaðýr
