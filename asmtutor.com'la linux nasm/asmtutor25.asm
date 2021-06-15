; asmtutor25.asm: SYS_READ ile açýlan disk dosyasýndaki mevcut kaydýn okunmasý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Merhaba, yaratýlýp içine kaydedilenin okunduðu disk dosyasý!
;----------------------------------------------------------------------------------------------------------------------------------
; ===25.Açýlan Dosya Kaydýnýn Okunmasý===
; EDX=okunacak dosya kaydý byte uzunluðu, ECX=Okunan kaydýn aktarýlacaðý bellek adresi, EBX=dönen dosya tasvir no,
; EAX=3=SYS_READ
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAdý db "mny1.txt", 0h
    YazýlanKayýt db "Merhaba, yaratýlýp içine kaydedilenin okunduðu disk dosyasý!", 0h

	SECTION .bss
    okunanKayýt resb 255	; Dosyadan okunacak kaydýn yüklebeceði deðiþken

	SECTION .text
    global _start
_start:
    mov ecx, 0777	; Yaratýlan dosya eriþimi (oku, yaz, koþtur)
    mov ebx, DosyaAdý
    mov eax, 8	; Baþvur 8=sys_creat
    int 80h

    mov edx, 65	; Dosyaya yazýlacak kayýt uzunluðu
    mov ecx, YazýlanKayýt
    mov ebx, eax	; Dosya tasvir no
    mov eax, 4	; Baþvur 4=sys_write
    int 80h

    mov ecx, 0	; Açýlacak dosya eriþimi (0=O_RDONLY
    mov ebx, DosyaAdý
    mov eax, 5	; Baþvur 5=sys=read
    int 80h

    mov edx, 65	; Dosyadan okunacak kaydýn uzunluðu
    mov ecx, okunanKayýt
    mov ebx, eax	; Açýlan dosya tasvir no
    mov eax, 3	; Baþvur 3=SYS_READ
    int 80h

    mov eax, okunanKayýt
    call dyazAS

    call son