; ----------------------------------------------------------------------------
; nasm004.asm: Komut sat�r� kelimelerini ekrana altalta yans�tan �rnek.
; nasm004 M.Nihat Yava� Ye�ilyurt-Malatya Toroslar - Mersin
; ----------------------------------------------------------------------------

    global _main
    extern _printf

	section .text
_main:
    mov ecx, [esp+4]	; arg0: komut sat�r�ndaki toplam arg�man say�s�
    mov edx, [esp+8]	; arg1: ilk arg�man endeksi
d�ng�:
    push ecx	; _printf yazd�r�rken kay�t��lar� y���na sakla
    push edx

    push dword [edx]	; ekrana yans�t�lacak akt�el arg�man
    push bi�imle 	; %s: string/dizge format�
    call _printf
    add esp, 8	; ilk 2 parametreyi sil

    pop edx	; -prinf'in kulland��� kay�t��lar� y���ndan al
    pop ecx

    add edx, 4	; bir sonraki endeksi g�ster
    dec ecx		; toplam arg�man say�s�n� bir d���r
    jnz d�ng�	; ecx s�f�r de�ilse d�ng�ye devam et

    ret
bi�imle:
    db "%s", 10, 0