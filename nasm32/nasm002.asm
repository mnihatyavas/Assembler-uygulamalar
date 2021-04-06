; nasm002.asm: Ýlk 40 fibonaki serisini hesaplayýp yazdýrma örneði.
;---------------------------------------------------------------------------------------------

	section .data
	section .bss
    global _main
    extern _printf	; C _printf fonksiyonu kullanýlacak

	section .text
_main:
    push ebx	; Bu kaydediciyi stack/yýðýna koyup sonradan kullanacaðýz

    mov ecx, 40	; ecx kaydedici 40'dan 0'a indirilecek
    xor eax, eax	; eax aktüel sayýyý tutacak
    xor ebx, ebx	; ebx birsonraki sayýyý tutacak
    inc ebx		; ebx bir artarak 0+1=1 oldu

yazdýr:
		; Yazdýrmak için_printf çaðrýlacak, ancak bu arada 
		; içerikler bozulmasýn diye eax, ebx, ecx saklanýp,
		; içerikleri sonradan tekrar yüklenecek

    push eax	; eax yýðýna saklanýyor
    push ecx	; ecx yýðýna saklanýyor

    push eax
    push biçimle
    call _printf
    add esp, 8

    pop ecx		; ecx yýðýndan alýnýyor
    pop eax	; eax yýðýndan alýnýyor

    mov edx, eax	; eax içeriði edx'e aktarýyor
    mov eax, ebx	; ebx içeriði eax'a aktarýlýyor
    add ebx, edx	; ebx=ebx+edx
    dec ecx		; 40'dan aþaðýya sayaç dþürülüyor
    jnz yazdýr	; JumpNotZero sýfýr deðilse yazdýr paragrafýna atla

    pop ebx	; dönüþ öncesi ebx yýðýndan alýnýyor
    ret
biçimle:
    db "%10d", 0

;---------------------------------------------------------------------------------------------
; nasm -fwin32 nasm002.asm
; gcc -m32 nasm002.obj -o nasm002.exe
; nasm002
;---------------------------------------------------------------------------------------------