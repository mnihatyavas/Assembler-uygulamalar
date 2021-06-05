; tut25.asm: Assembler kullan�m�na hatas�z eny�ksek belle�i tahsis etme �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Program kullanimina 16kb'lik bellek alani tahsis edilmistir!
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===BELLEK Y�NET�M�===
; sys_brk() ile ebx'e atanan en�st bellek adresi kullan�labilir, kernel �a�r�s�nda hata eax'e -1 d�nd�r�r.
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov eax, 45	; sys_brk �a�r� numaras�
    xor ebx, ebx	; farkl�ysa 1, ebx=0
    int 80h		; s�f�r bellek tahsisat�

    add eax, 16384	; 2^14=16384=16kb bellek tahsisat� yap�lacak
    mov ebx, eax
    mov eax, 45	; sys_brk
    int 80h		; 16kb bellek tahsisat� hatas�zsa eax'e d�ner

    cmp eax, 0
    jl ��k��		; y�ksek tahsisat hatal�ysa eax <= 1
    mov edi, eax	; de�ilse EDI=16384
    sub edi, 4	; son DWORD i�aret edilir
    mov ecx, 4096	; saya�'a tahsis edilen DWORD say�s� (16384 / 4)
    xor eax, eax	; eax=0
    std		; SetDirection (geriye)
    rep stosd	; StoreDW (saya� adedince tekrarlave eax=0'� t�m 16kb tahsisata yaz)
    cld		; ClearDirection (ileriye)

    mov eax, 4	; 4=yaz
    mov ebx, 1	; 1=ekran
    mov ecx, Mesaj	; Mesaj
    mov edx, Uzunluk ; Uzunluk
    int 80h

��k��:
    mov eax, 1	; 1=��k
    ;xor ebx, ebx	; ebx=0
    int 80h

	section .data
    Mesaj db "Program kullan�m�na 16kb'l�k bellek alan� tahsis edilmi�tir!", 10	; 0xa
    Uzunluk equ $ - Mesaj