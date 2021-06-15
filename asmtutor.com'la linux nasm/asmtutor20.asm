; asmtutor20.asm: SYS_FORK ile çatallaþan ebeveyn veya çocuk iþlemleri örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Bu bir ebeveyn iþlemidir
; 
Bu bir yavru iþlemidir

;----------------------------------------------------------------------------------------------------------------------------------
; ===20.Ýþlem Çatallanmasý===
; EAX=2 sys_fork iþlem çatallanmasýný baþvurur.
; Dönen deðer sýfýrsa yavru iþlemdeyiz, pozitif tamsayýysa ebeveyn iþlemdeyiz demektir,
; þartlara uygun kodlama yönelim yönetimi yapýlabilir.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    YavruMesajý db "Bu bir yavru iþlemidir", 0h
    EbeveynMesajý db "Bu bir ebeveyn iþlemidir", 0h

	SECTION .text
    global _start
_start:
    mov eax, 2	; Baþvuru 2=SYS_FORK
    int 80h

    cmp eax, 0
    jz yavru		; Sýfýrsa yavru iþlemdeyizdir

ebeveyn:
    mov eax, EbeveynMesajý	; Ebeveyn iþlemdeyiz
    call dyazAS
    call son

yavru:
    mov eax, YavruMesajý	; Yavru iþlemdeyiz
    call dyazAS
    call son