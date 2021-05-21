; ----------------------------------------------------------------------------------------------------------------------------------------------
; nasm003.asm: Ana program C'den argümanlar alarak çaðrýlan fonksiyon sonucunu döndürme örneði.
; Çaðrýlan fonksiyon:  int enBuyugu (int x, int y, int z)
; Gönderilen argüman deðerleri eax, ecx, edx kaydedicilerine aktarýlýyor
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
    mov edx, [esp+12]		; Argümanlar kaydedicilere aktarýldý
    cmp eax, ecx		; Ýlk argüman ikinciyle karþýlaþtýrýlýyor
    cmovl eax, ecx		; Eðer ilki küçükse ilk kaydediciye ikinci aktarýlýyor
    cmp eax, edx		; Ýlk argüman üçüncüyle karþýlaþtýrýlýyor
    cmovl eax, edx		; Eðer ilki küçükse ilk kaydediciye üçüncüdeki deðer aktarýlýyor
    ret			; Sonuç int/tamsayý olarak eax'dan geri döndürülüyor
