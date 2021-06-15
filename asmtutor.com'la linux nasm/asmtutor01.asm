; asmtutor01.asm: Kernel �a�r�s� i�in ilk 4 kay�t��lar�n kullan�m� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/" �evrimi�i derleyici/nasm ve ba�lay�c� kullan�lmaktad�r.
; $ nasm -f elf asmtutor01.asm
; $ ld -m elf_i386 asmtutor01.o -o asmtutor01
;
; Merhaba asmtutor.com linux nasm d�nyas�
; "Segmentation fault" hatas�
;----------------------------------------------------------------------------------------------------------------------------------
; ===1.Merhaba D�nya===
; kernel �a�r�s� "int 80h" i�in eax, ebx, ecx, edx kay�t��lar�n g�revleri.
;----------------------------------------------------------------------------------------------------------------------------------

	SECTION .data
    Mesaj db "Merhaba asmtutor.com linux nasm d�nyas�!", 0Ah

	SECTION .text
    global _start
_start:
    mov edx, 41	; uzunluk = i�erik + 1 (0Ah i�in)
    mov ecx, Mesaj	; Mesaj�m�z�n bellek adresi
    mov ebx, 1	; 1=STDOUT/ekran
    mov eax, 4	; 4=SYS_WRITE (invoke/ba�vur kernel opcode 4)
    int 80h		; kernel �a�r�s�