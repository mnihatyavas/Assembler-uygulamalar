; asmtutor24.asm: SYS_OPEN ile yratýlan disk dosyasýnýn açýlmasý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Dönen dosya açýlma tasvir no: 4
;----------------------------------------------------------------------------------------------------------------------------------
; ===24.Yaratýlan Disk Dosyasýnýn Açýlmasý===
; ECX=eriþim (0=O_RDONLY, 1=O_WRONLY, 2=O_RDWR), EBX=açýlacak dosya adý, EAX=5=sys_open
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAdý db "mny1.txt", 0h
    Kayýt db "Merhaba, yaratýlýp açýlacak disk dosyasý!", 0h

	SECTION .text
    global _start
_start:
    mov ecx, 0777	; Yaratýlacak dosya eriþimi (oku, yaz, koþtur)
    mov ebx, DosyaAdý
    mov eax, 8	; 8=sys_creat
    int 80h

    mov edx, 41	; Dosyaya yazýlacak kayýt uzunluðu
    mov ecx, Kayýt
    mov ebx, eax	; Dönen dosya tasviri
    mov eax, 4	; 4=sys_write
    int 80h

    mov ecx, 0	; Açýlma eriþimi (0=O_RDONLY)
    mov ebx, DosyaAdi
    mov eax, 5	; Baþvur 5=SYS_OPEN
    int 80h

    call tyazAS	; EAX'daki dönen dosya tasnir no
    call son