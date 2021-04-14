; nasm002.asm: �lk 40 fibonaki serisini hesaplay�p yazd�rma �rne�i.
;---------------------------------------------------------------------------------------------

	section .data
	section .bss
    global _main
    extern _printf	; C _printf fonksiyonu kullan�lacak

	section .text
_main:
    push ebx	; Bu kaydediciyi stack/y���na koyup sonradan kullanaca��z

    mov ecx, 40	; ecx kaydedici 40'dan 0'a indirilecek
    xor eax, eax	; eax akt�el say�y� tutacak
    xor ebx, ebx	; ebx birsonraki say�y� tutacak
    inc ebx		; ebx bir artarak 0+1=1 oldu

yazd�r:
		; Yazd�rmak i�in_printf �a�r�lacak, ancak bu arada 
		; i�erikler bozulmas�n diye eax, ebx, ecx saklan�p,
		; i�erikleri sonradan tekrar y�klenecek

    push eax	; eax y���na saklan�yor
    push ecx	; ecx y���na saklan�yor

    push eax
    push bi�imle
    call _printf
    add esp, 8

    pop ecx		; ecx y���ndan al�n�yor
    pop eax	; eax y���ndan al�n�yor

    mov edx, eax	; eax i�eri�i edx'e aktar�yor
    mov eax, ebx	; ebx i�eri�i eax'a aktar�l�yor
    add ebx, edx	; ebx=ebx+edx
    dec ecx		; 40'dan a�a��ya saya� d��r�l�yor
    jnz yazd�r	; JumpNotZero s�f�r de�ilse yazd�r paragraf�na atla

    pop ebx	; d�n�� �ncesi ebx y���ndan al�n�yor
    ret
bi�imle:
    db "%10d", 0

;---------------------------------------------------------------------------------------------
; nasm -fwin32 nasm002.asm
; gcc -m32 nasm002.obj -o nasm002.exe
; nasm002
;---------------------------------------------------------------------------------------------