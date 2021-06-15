; asmtutor01.asm: Kernel çaðrýsý için ilk 4 kayýtçýlarýn kullanýmý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/" çevrimiçi derleyici/nasm ve baðlayýcý kullanýlmaktadýr.
; $ nasm -f elf asmtutor01.asm
; $ ld -m elf_i386 asmtutor01.o -o asmtutor01
;
; Merhaba asmtutor.com linux nasm dünyasý
; "Segmentation fault" hatasý
;----------------------------------------------------------------------------------------------------------------------------------
; ===1.Merhaba Dünya===
; kernel çaðrýsý "int 80h" için eax, ebx, ecx, edx kayýtçýlarýn görevleri.
;----------------------------------------------------------------------------------------------------------------------------------

	SECTION .data
    Mesaj db "Merhaba asmtutor.com linux nasm dünyasý!", 0Ah

	SECTION .text
    global _start
_start:
    mov edx, 41	; uzunluk = içerik + 1 (0Ah için)
    mov ecx, Mesaj	; Mesajýmýzýn bellek adresi
    mov ebx, 1	; 1=STDOUT/ekran
    mov eax, 4	; 4=SYS_WRITE (invoke/baþvur kernel opcode 4)
    int 80h		; kernel çaðrýsý