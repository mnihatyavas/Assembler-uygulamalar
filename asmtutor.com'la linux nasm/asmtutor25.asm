; asmtutor25.asm: SYS_READ ile a��lan disk dosyas�ndaki mevcut kayd�n okunmas� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Merhaba, yarat�l�p i�ine kaydedilenin okundu�u disk dosyas�!
;----------------------------------------------------------------------------------------------------------------------------------
; ===25.A��lan Dosya Kayd�n�n Okunmas�===
; EDX=okunacak dosya kayd� byte uzunlu�u, ECX=Okunan kayd�n aktar�laca�� bellek adresi, EBX=d�nen dosya tasvir no,
; EAX=3=SYS_READ
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAd� db "mny1.txt", 0h
    Yaz�lanKay�t db "Merhaba, yarat�l�p i�ine kaydedilenin okundu�u disk dosyas�!", 0h

	SECTION .bss
    okunanKay�t resb 255	; Dosyadan okunacak kayd�n y�klebece�i de�i�ken

	SECTION .text
    global _start
_start:
    mov ecx, 0777	; Yarat�lan dosya eri�imi (oku, yaz, ko�tur)
    mov ebx, DosyaAd�
    mov eax, 8	; Ba�vur 8=sys_creat
    int 80h

    mov edx, 65	; Dosyaya yaz�lacak kay�t uzunlu�u
    mov ecx, Yaz�lanKay�t
    mov ebx, eax	; Dosya tasvir no
    mov eax, 4	; Ba�vur 4=sys_write
    int 80h

    mov ecx, 0	; A��lacak dosya eri�imi (0=O_RDONLY
    mov ebx, DosyaAd�
    mov eax, 5	; Ba�vur 5=sys=read
    int 80h

    mov edx, 65	; Dosyadan okunacak kayd�n uzunlu�u
    mov ecx, okunanKay�t
    mov ebx, eax	; A��lan dosya tasvir no
    mov eax, 3	; Ba�vur 3=SYS_READ
    int 80h

    mov eax, okunanKay�t
    call dyazAS

    call son