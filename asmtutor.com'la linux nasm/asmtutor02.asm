; asmtutor02.asm: Program� hatas�z sonland�rma �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Merhaba hatas�z asmtutor.com linux nasm d�nyas�!
;----------------------------------------------------------------------------------------------------------------------------------
; ===2.Do�ru Program ��k���===
; Program kodlamas� global start: tan ba�lar,sonu�land���n� anlamak i�in eax=1=sys_exit bekler,
; yoksa "segmentation error" b�l�m hatas� verir.
;----------------------------------------------------------------------------------------------------------------------------------

	SECTION .data
    Mesaj db "Merhaba hatas�z asmtutor.com linux nasm d�nyas�!", 0Ah

	SECTION .text
    global _start
_start:
    mov edx, 51	; uzunluk = i�erik + 1 (0Ah i�in)
    mov ecx, Mesaj	; Mesaj�m�z�n bellek adresi
    mov ebx, 1	; 1=STDOUT/ekran
    mov eax, 4	; 4=SYS_WRITE (invoke/ba�vur kernel opcode 4)
    int 80h		; kernel �a�r�s�

    mov ebx, 0	; ��k��ta eax'a "0"="Hata Yok" d�nd�r�r
    mov eax, 1	; 1=SYS_EXIT (��k�� kernel opcode 1)
    int 80h