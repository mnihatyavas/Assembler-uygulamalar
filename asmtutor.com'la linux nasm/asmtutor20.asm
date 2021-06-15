; asmtutor20.asm: SYS_FORK ile �atalla�an ebeveyn veya �ocuk i�lemleri �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Bu bir ebeveyn i�lemidir
; 
Bu bir yavru i�lemidir

;----------------------------------------------------------------------------------------------------------------------------------
; ===20.��lem �atallanmas�===
; EAX=2 sys_fork i�lem �atallanmas�n� ba�vurur.
; D�nen de�er s�f�rsa yavru i�lemdeyiz, pozitif tamsay�ysa ebeveyn i�lemdeyiz demektir,
; �artlara uygun kodlama y�nelim y�netimi yap�labilir.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    YavruMesaj� db "Bu bir yavru i�lemidir", 0h
    EbeveynMesaj� db "Bu bir ebeveyn i�lemidir", 0h

	SECTION .text
    global _start
_start:
    mov eax, 2	; Ba�vuru 2=SYS_FORK
    int 80h

    cmp eax, 0
    jz yavru		; S�f�rsa yavru i�lemdeyizdir

ebeveyn:
    mov eax, EbeveynMesaj�	; Ebeveyn i�lemdeyiz
    call dyazAS
    call son

yavru:
    mov eax, YavruMesaj�	; Yavru i�lemdeyiz
    call dyazAS
    call son