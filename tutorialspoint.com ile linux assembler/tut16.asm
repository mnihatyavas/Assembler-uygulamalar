; tut16.asm: Ekrana 0,1,2,3,4,5,6,7,8,9 yazma �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 0123456789
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===D�NG�LER===
; 10 kezlik d�ng�:
; MOV CL, 10
; D1:
; <D�ng�-g�vdesi>
; DEC CL
; JNZ D1
;
; mov ECX,10
; d1:
; <d�ng� g�vdesi>
; loop d1 ; Loop komutu ECX'i otomatikmen 1 d���r�r
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov ecx,10
    mov eax, "0"
d1:
    mov [say�], eax
    mov eax, 4	; 4=yaz
    mov ebx, 1	; 1=ekran
    push ecx	; ECX y���na konulmal�, zira kernel �a�r�ld���nda i�eri�ini (akt�el say�'y�) ekrana yazd�racak
    mov ecx, say�
    mov edx, 1	; uzunluk=1 byte
    int 0x80

    mov eax, [say�]
    sub eax, "0"	; ascii'den ondal��a
    inc eax		; eax +=1 ; 0,1,2,3,..9
    add eax, "0"	; ondal�ktan ascii'ye
    pop ecx		; y���ndan ECX al�n�r
    loop d1		; ECX saya� s�f�r olucaya dek d�ng�ye devam eder

    mov eax,1	; 1=son
    int 0x80

	section .bss
    say� resb 1