; asmtutor02.asm: Programý hatasýz sonlandýrma örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Merhaba hatasýz asmtutor.com linux nasm dünyasý!
;----------------------------------------------------------------------------------------------------------------------------------
; ===2.Doðru Program Çýkýþý===
; Program kodlamasý global start: tan baþlar,sonuçlandýðýný anlamak için eax=1=sys_exit bekler,
; yoksa "segmentation error" bölüm hatasý verir.
;----------------------------------------------------------------------------------------------------------------------------------

	SECTION .data
    Mesaj db "Merhaba hatasýz asmtutor.com linux nasm dünyasý!", 0Ah

	SECTION .text
    global _start
_start:
    mov edx, 51	; uzunluk = içerik + 1 (0Ah için)
    mov ecx, Mesaj	; Mesajýmýzýn bellek adresi
    mov ebx, 1	; 1=STDOUT/ekran
    mov eax, 4	; 4=SYS_WRITE (invoke/baþvur kernel opcode 4)
    int 80h		; kernel çaðrýsý

    mov ebx, 0	; Çýkýþta eax'a "0"="Hata Yok" döndürür
    mov eax, 1	; 1=SYS_EXIT (çýkýþ kernel opcode 1)
    int 80h