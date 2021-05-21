; pcasm1b.asm: Tüm ASM programlarda kullanýlacak iskelet yapý örneði.
;
; nasm -fwin32 pcasm1b.asm
; gcc -m32 pcasm1b.obj pcasm.c asm_io.obj -o pcasm1b.exe
;--------------------------------------------------------------------------------------------------------
    %include "asm_io.inc"
	segment .data
;
; initialized data is put in the data segment here
;

	segment .bss
;
; uninitialized data is put in the bss segment
 ;

	segment .text
    global _esas_kodlama
_esas_kodlama:
    enter 0, 0	; Kurulum rutini
    pusha

;
; Kodlama satýrlarý bu kýsýmda bulunmalý. Öncesi vesonrasý deðiþtirilmesin.
;

    popa
    mov eax, 0	; Tekrar C'ye dönüþ
    leave
    ret