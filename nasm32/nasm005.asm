; ----------------------------------------------------------------------------
; nasm005.asm: Komut sat�r�ndan girilen tamsay� x^y sonucunu veren �rnek.
; ----------------------------------------------------------------------------

    global _main
    extern _atoi		; komut sat�r�ndan girileni tamsay�ya �eviren C fonksiyonu
    extern _printf		; sonucu ekrana yazd�ran C fonksiyonu

	section .text
_main:
    push ebx		; kullan�lacak kay�t��lar� y���na koy
    push esi
    push edi

    mov eax, [esp+16]		; argc (komut sat�r� arg�man say�s�n�/counter ta��)
    cmp eax, 3		; tam 2 arg�man olmal� (prg.ad'la beraber 3)
    jne hata1		; e�it de�ilse hata1'e atla

    mov ebx, [esp+20]		; argv (komut sat�r� arg�manlar�n�/value ta��)
    push dword [ebx+4]	; argv [1] (ilk arg�man� y���na koy: temel=x, argv[0] prg.ad�)
    call _atoi		; dizgeden tamsay�ya �evir
    add esp, 4
    mov esi, eax		; x'i esi'ye ta��
    push dword [ebx+8]	; argv [2] (ikinci arg�man� y���na koy: �s=y)
    call _atoi		; dizgeden tamsay�ya �evir
    add esp, 4
    cmp eax, 0		; �s'� 0'la k�yasla
    jl hata2			; negatifse hata2'ye atla
    mov edi, eax		; y'yi edi'ye ta��

    mov eax, 1		; eax = 1
kontrol:
    test edi, edi		; we're counting y downto 0
    jz sonucuYaz			; tamamland�
    imul eax, esi		; eax = eax * esi
    dec edi			; edi �s defa esi kendisiyle �arp�lacak
    jmp kontrol
sonucuYaz:					; print report on success
    push eax
    push bi�imleme
    call _printf
    add esp, 8
    jmp tamamland�
hata1:			; arg�man say�s� hatas�n� yans�t
    push hatal�Arg�manSay�s�
    call _printf
    add esp, 4
    jmp tamamland�
hata2:			; �s de�erin negatif girilme hatas�n� yans�t
    push negatif�sHatas�
    call _printf
    add esp, 4
tamamland�:		; saklanan kay�t��lar� filo ��kar/sil
    pop edi
    pop esi
    pop ebx
    ret			; program� sonland�r

bi�imleme:
    db "Sonu�=%d", 10, 0
hatal�Arg�manSay�s�:
    db "Eksiksiz fazlas�z iki tamsay� de�er girmelisiniz...", 10, 0
negatif�sHatas�:
    db "�s negatif olamaz...", 10, 0