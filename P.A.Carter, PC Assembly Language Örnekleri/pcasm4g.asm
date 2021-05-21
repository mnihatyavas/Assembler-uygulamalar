; pcasm4g.asm: Girilen n'in fakt�ryelini hesaplama �rne�i.
;
; nasm -fwin32 pcasm4g.asm
; gcc -m32 pcasm4g.c asm_io.obj pcasm4g.obj
; a
;--------------------------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"

	segment .text
    global _faktoryal
;;
;; yerel de�i�ken:
;;    �arp�m (konumu [ebp-4])
_faktoryal:
    enter 0, 0
    mov eax, [ebp+8]		; eax = n
    cmp eax, 1
    jbe sonland�r		; if  n <= 1, sonland�r
    dec eax
    push eax
    call _faktoryal		; eax = faktoryal (n - 1)
    pop ecx
    mul dword [ebp+8]	; edx:eax = eax * [ebp+8]
    jmp short faktoryal_sonu
sonland�r:
    mov eax, 1
faktoryal_sonu:
    leave
    ret