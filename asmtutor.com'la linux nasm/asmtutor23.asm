; asmtutor23.asm: SYS_WRITE ile yratýlan disk dosyasýna kayýt yazýlmasý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Yaratýlan "mny1.txt" dosyasýna "Merhaba, disk dosyasý!" kaydý yazýlýr.
;----------------------------------------------------------------------------------------------------------------------------------
; ===23.Disk Dosyasýna Yazma===
; ECX=kayýt uzunluðu, EDX=yazýlacak dizge, EBX=dosya tasviri, EAX=4=sys_write
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAdý db "mny1.txt", 0h
    Kayýt db "Merhaba, disk dosyasý!", 0h

	SECTION .text
    global _start
_start:
    mov ecx, 0777	; dosya yaratma eriþimleri
    mov ebx, DosyaAdý
    mov eax, 8	; Baþvuru 8=sys_creat
    int 80h

    mov edx, 22	; Kayýt uzunluðu
    mov ecx, Kayýt
    mov ebx, eax	; Yaratýlýrken dönen dosya tasviri
    mov eax, 4	; Baþvuru 4=SYS_WRITE
    int 80h

    call son