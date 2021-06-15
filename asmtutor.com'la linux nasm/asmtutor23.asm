; asmtutor23.asm: SYS_WRITE ile yrat�lan disk dosyas�na kay�t yaz�lmas� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Yarat�lan "mny1.txt" dosyas�na "Merhaba, disk dosyas�!" kayd� yaz�l�r.
;----------------------------------------------------------------------------------------------------------------------------------
; ===23.Disk Dosyas�na Yazma===
; ECX=kay�t uzunlu�u, EDX=yaz�lacak dizge, EBX=dosya tasviri, EAX=4=sys_write
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAd� db "mny1.txt", 0h
    Kay�t db "Merhaba, disk dosyas�!", 0h

	SECTION .text
    global _start
_start:
    mov ecx, 0777	; dosya yaratma eri�imleri
    mov ebx, DosyaAd�
    mov eax, 8	; Ba�vuru 8=sys_creat
    int 80h

    mov edx, 22	; Kay�t uzunlu�u
    mov ecx, Kay�t
    mov ebx, eax	; Yarat�l�rken d�nen dosya tasviri
    mov eax, 4	; Ba�vuru 4=SYS_WRITE
    int 80h

    call son