; asmtutor22.asm: SYS_CREAT ile disk �zerinde metin dosyas� yaratma �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; "mny1.txt" dosyas� yarat�l�r.
;----------------------------------------------------------------------------------------------------------------------------------
; ===22.Disk Dosyas� Yaratma===
; EAX=8=sys_creat ile disk dosyas� yarat�l�r. EBX=dosyaAd�, ECX=eri�im tipi (read/oku, write/yaz, execute/�al��t�r)
; Yarat�lan dosyan�n dsoya tasviri EAX'a d�ner ve bu tasvir, sonraki dosya y�netimlerinde kullan�l�r.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAd� db "mny1.txt", 0h	; Yarat�lacak dosyan�n ad�

	SECTION .text
    global _start
_start:
    mov ecx, 0777	; T�m eri�im izinleri (read, write, execute)
    mov ebx, DosyaAd�
    mov eax, 8	; EAX=8 (ba�vur SYS_CREAT)
    int 80h
    call son