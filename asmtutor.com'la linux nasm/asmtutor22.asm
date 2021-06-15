; asmtutor22.asm: SYS_CREAT ile disk üzerinde metin dosyasý yaratma örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; "mny1.txt" dosyasý yaratýlýr.
;----------------------------------------------------------------------------------------------------------------------------------
; ===22.Disk Dosyasý Yaratma===
; EAX=8=sys_creat ile disk dosyasý yaratýlýr. EBX=dosyaAdý, ECX=eriþim tipi (read/oku, write/yaz, execute/çalýþtýr)
; Yaratýlan dosyanýn dsoya tasviri EAX'a döner ve bu tasvir, sonraki dosya yönetimlerinde kullanýlýr.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAdý db "mny1.txt", 0h	; Yaratýlacak dosyanýn adý

	SECTION .text
    global _start
_start:
    mov ecx, 0777	; Tüm eriþim izinleri (read, write, execute)
    mov ebx, DosyaAdý
    mov eax, 8	; EAX=8 (baþvur SYS_CREAT)
    int 80h
    call son