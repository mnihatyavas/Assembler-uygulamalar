; asmtutor27.asm: SYS_LSEEK ile mevcut dosya i�erik konumunda g�ncelleme �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
;----------------------------------------------------------------------------------------------------------------------------------
; ===27.Dosya Y�netimi (G�ncelleme)===
; EAX=19=SYS_LSEEK, EBX=Dosya tasvir no, EDX: (0=SEEK_SET, 1=SEEK_CUR, 2=SEEK_END),
; ECX=Telafi adresi
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAd� db "mny1.txt", 0h
    G�ncellemeKayd� db "-g�ncellendi-", 0h

	SECTION .text
    global _start
_start:
    mov ecx, 1	; Eri�im (1=O_WRONLY)
    mov ebx, DosyaAd�
    mov eax, 5	; Ba�vur (5=SYS_OPEN)
    int 80h

    mov edx, 2	; Dosya sonu (2=SEEK_END)
    mov ecx, 0	; Telafi adresi 0 byte ileri
    mov ebx, eax	; Dosya a�ma tasvir no
    mov eax, 19	; Ba�vur (19=SYS_LSEEK)
    int 80h

    mov edx, 13	; Uzunluk
    mov ecx, G�ncellemeKayd�
    mov ebx, ebx	; Dosya tasvir no
    mov eax, 4	; Ba�vur (4=SYS_WRITE)
    int 80h

    call son