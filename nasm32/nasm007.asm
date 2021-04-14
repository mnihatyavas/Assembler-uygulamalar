; ----------------------------------------------------------------------------
; nasm007.asm: Altalta 2^0'den 2^31'e �sl� sonu�lar� d�k�mleyen �rnek.
;
;  nasm -fwin32 nasm007.asm
;  gcc -m32 nasm007.obj" -o nasm007.exe
; ----------------------------------------------------------------------------

    extern _printf
    global _main

	section .text
_main:
    push esi	; source index/kaynak-endeks kay�t��y� y���na sakla
    push edi	; destination index/hedef-endeks kay�t��y� y���na sakla

    mov esi, 1	; ilk �s de�erini esi'ye koy
    mov edi, 31	; son �s de�erini edi'ye koy
prgf1:
    push esi	; yazd�r�lacak de�eri y���na koy
    push bi�imle	; bi�imle dizge adresini y���na koy
    call _printf	; ekrana yazd�r
    add esp, 8	; _printf'e aktar�lan parametreleri y���ndan ��kar/sil (g�stergeyi atlat)
    add esi, esi	; esi de�erini ikiye katla (1+1=2, 2+2=4, 4+4=8 vb)
    dec edi		; edi sayac�n� bir indir (edi=edi-1)
    jnz prgf1	; sonu� s�f�r de�ilse prgf1'e git

    pop edi		; y���ndan edi'yi ��kar/sil
    pop esi		; y���ndan esi'yi ��kar/sil
    ret		; gerid�n, program� sonland�r

bi�imle: db "%d", 10, 0