; asmtutor24.asm: SYS_OPEN ile yrat�lan disk dosyas�n�n a��lmas� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; D�nen dosya a��lma tasvir no: 4
;----------------------------------------------------------------------------------------------------------------------------------
; ===24.Yarat�lan Disk Dosyas�n�n A��lmas�===
; ECX=eri�im (0=O_RDONLY, 1=O_WRONLY, 2=O_RDWR), EBX=a��lacak dosya ad�, EAX=5=sys_open
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAd� db "mny1.txt", 0h
    Kay�t db "Merhaba, yarat�l�p a��lacak disk dosyas�!", 0h

	SECTION .text
    global _start
_start:
    mov ecx, 0777	; Yarat�lacak dosya eri�imi (oku, yaz, ko�tur)
    mov ebx, DosyaAd�
    mov eax, 8	; 8=sys_creat
    int 80h

    mov edx, 41	; Dosyaya yaz�lacak kay�t uzunlu�u
    mov ecx, Kay�t
    mov ebx, eax	; D�nen dosya tasviri
    mov eax, 4	; 4=sys_write
    int 80h

    mov ecx, 0	; A��lma eri�imi (0=O_RDONLY)
    mov ebx, DosyaAdi
    mov eax, 5	; Ba�vur 5=SYS_OPEN
    int 80h

    call tyazAS	; EAX'daki d�nen dosya tasnir no
    call son