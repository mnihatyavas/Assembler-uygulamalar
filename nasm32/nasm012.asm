; nasm012.asm: C'den gönderilen tamsayýnýn faktöriyelini hesaplayýp döndürme örneði.
;
; nasm -fwin32 nasm012.asm
; gcc -m32 nasm012.obj nasm012.c
; a
;--------------------------------------------------------------------------------------------------------------------------

	SECTION .text	; kodlama bölümü
    global _faktoriyal		; win32

_faktoriyal:
    push ebp		; Yemel gösterge'yi yýðýna sakla
    mov ebp, esp		; Yýðýn göstergeyi temel'e kopyala
    push ecx		; Sayaç kayýtçý'yý yýðýna sakla

    mov ecx, [ebp+8]		; Sayaç kayýtçýya ilk argümaný al
    mov eax, 1		; Toplayýcý kayýtçýya 1 aktar

anadöngü:
    cmp ecx, 0		; if (ecx == 0)
    jz tamamlandý		; tamamlandý etikete git
    mul ecx			; else eax = eax * ecx
    dec ecx			; ecx = ecx - 1
    jmp anadöngü

tamamlandý:
    pop ecx			; Yýðýndan ecx'i çýkar/sil
    pop ebp		; Yýðýndan ebp'yi sil
    ret			; Çaðýran C fonksiyonuna dön