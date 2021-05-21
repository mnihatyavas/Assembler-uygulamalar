; ----------------------------------------------------------------------------------------------------------------------------------------------
; nasm003.asm: Ana program C'den arg�manlar alarak �a�r�lan fonksiyon sonucunu d�nd�rme �rne�i.
; �a�r�lan fonksiyon:  int enBuyugu (int x, int y, int z)
; G�nderilen arg�man de�erleri eax, ecx, edx kaydedicilerine aktar�l�yor
;
; nasm -fwin32 nasm003.asm
; gcc -m32 nasm003.obj nasm003.c -o nasm003.exe
; nasm003
; ----------------------------------------------------------------------------------------------------------------------------------------------

    global _enBuyugu
	section .text
_enBuyugu:
    mov eax, [esp+4]
    mov ecx, [esp+8]
    mov edx, [esp+12]		; Arg�manlar kaydedicilere aktar�ld�
    cmp eax, ecx		; �lk arg�man ikinciyle kar��la�t�r�l�yor
    cmovl eax, ecx		; E�er ilki k���kse ilk kaydediciye ikinci aktar�l�yor
    cmp eax, edx		; �lk arg�man ���nc�yle kar��la�t�r�l�yor
    cmovl eax, edx		; E�er ilki k���kse ilk kaydediciye ���nc�deki de�er aktar�l�yor
    ret			; Sonu� int/tamsay� olarak eax'dan geri d�nd�r�l�yor
