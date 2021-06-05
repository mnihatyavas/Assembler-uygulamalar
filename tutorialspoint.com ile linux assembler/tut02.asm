; tut02.asm: B�l�m ad� section yada segment �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Tekrar merhaba, �evrimi�i linux nasm assembler d�nyas�!
;--------------------------------------------------------------------------------------------------------------------------
; ===BELLEK B�L�MLER�===
; B�l�m ad� i�in section yada segment kullan�lmas� farketmez.
;--------------------------------------------------------------------------------------------------------------------------

	segment .data
    Mesaj db "Tekrar merhaba, �evrimi�i linux nasm assembler d�nyas�!", 0xa	; =10: yazd�r�lacak dizge
    Uzunluk equ $ - Mesaj	; Mesaj dizgesinin uzunlu�u

    global _start	; ba�lay�c�/linker=ld i�in beyan� mecburidir
	segment .text
_start:	; kodlamaya ilk giri� noktas�
    mov edx, Uzunluk		; Mesaj uzunlu�u, EDX/DataRegister/VeriKay�t��
    mov ecx, Mesaj		; Yazd�r�lacak Mesaj, ECX/CounterRegister/Saya�Kay�t��
    mov ebx,1		; Yazd�r�lacak dosya no=1 (stdout/standart-��kt�), EBX/BaseRegister/TemelKay�t��
    mov eax, 4		; Sistem call/�a��r no=4 (sys_write/yaz), EAX/AccumulatorRegister/Toplay�c�Kay�t��
    int 0x80			; Kernel'i yazd�rma i�in call/�a��r
    mov eax,1		; Sistem �a��r no=1 (sys_exit/��k)
    int 0x80			; Kernell'i ��k�� i�in �a��r
