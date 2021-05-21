; nasm012.asm: C'den g�nderilen tamsay�n�n fakt�riyelini hesaplay�p d�nd�rme �rne�i.
;
; nasm -fwin32 nasm012.asm
; gcc -m32 nasm012.obj nasm012.c
; a
;--------------------------------------------------------------------------------------------------------------------------

	SECTION .text	; kodlama b�l�m�
    global _faktoriyal		; win32

_faktoriyal:
    push ebp		; Yemel g�sterge'yi y���na sakla
    mov ebp, esp		; Y���n g�stergeyi temel'e kopyala
    push ecx		; Saya� kay�t��'y� y���na sakla

    mov ecx, [ebp+8]		; Saya� kay�t��ya ilk arg�man� al
    mov eax, 1		; Toplay�c� kay�t��ya 1 aktar

anad�ng�:
    cmp ecx, 0		; if (ecx == 0)
    jz tamamland�		; tamamland� etikete git
    mul ecx			; else eax = eax * ecx
    dec ecx			; ecx = ecx - 1
    jmp anad�ng�

tamamland�:
    pop ecx			; Y���ndan ecx'i ��kar/sil
    pop ebp		; Y���ndan ebp'yi sil
    ret			; �a��ran C fonksiyonuna d�n