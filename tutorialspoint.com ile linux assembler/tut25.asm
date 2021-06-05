; tut25.asm: Assembler kullanýmýna hatasýz enyüksek belleði tahsis etme örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Program kullanimina 16kb'lik bellek alani tahsis edilmistir!
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===BELLEK YÖNETÝMÝ===
; sys_brk() ile ebx'e atanan enüst bellek adresi kullanýlabilir, kernel çaðrýsýnda hata eax'e -1 döndürür.
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov eax, 45	; sys_brk çaðrý numarasý
    xor ebx, ebx	; farklýysa 1, ebx=0
    int 80h		; sýfýr bellek tahsisatý

    add eax, 16384	; 2^14=16384=16kb bellek tahsisatý yapýlacak
    mov ebx, eax
    mov eax, 45	; sys_brk
    int 80h		; 16kb bellek tahsisatý hatasýzsa eax'e döner

    cmp eax, 0
    jl çýkýþ		; yüksek tahsisat hatalýysa eax <= 1
    mov edi, eax	; deðilse EDI=16384
    sub edi, 4	; son DWORD iþaret edilir
    mov ecx, 4096	; sayaç'a tahsis edilen DWORD sayýsý (16384 / 4)
    xor eax, eax	; eax=0
    std		; SetDirection (geriye)
    rep stosd	; StoreDW (sayaç adedince tekrarlave eax=0'ý tüm 16kb tahsisata yaz)
    cld		; ClearDirection (ileriye)

    mov eax, 4	; 4=yaz
    mov ebx, 1	; 1=ekran
    mov ecx, Mesaj	; Mesaj
    mov edx, Uzunluk ; Uzunluk
    int 80h

çýkýþ:
    mov eax, 1	; 1=çýk
    ;xor ebx, ebx	; ebx=0
    int 80h

	section .data
    Mesaj db "Program kullanýmýna 16kb'lýk bellek alaný tahsis edilmiþtir!", 10	; 0xa
    Uzunluk equ $ - Mesaj