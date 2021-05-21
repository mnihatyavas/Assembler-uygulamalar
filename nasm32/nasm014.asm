; nasm014.asm: Ekrandan girilen 2 tamsayýnýn toplamýný yazdýran örnek.
;
; nasm -fwin32 nasm014.asm
; gcc -m32 nasm014.obj -o nasm014.exe
; nasm014
;-----------------------------------------------------------------------------------------------------------

	SECTION .data
    mesaj1: db "Ýlk tamsayýyý girin: ", 0
    mesaj2: db "Ýkinci tamsayýyý girin: ", 0
    girdiBiçimi: db "%d", 0
    çýktýBiçimi: db "Girilen 2 tamsayýnýn toplamý: %d",  0	; Altsatýr
    tamsayý1: times 4 db 0 ; 32-bits tamsayý = 4 bytes
    tamsayý2: times 4 db 0

	SECTION .text
    global _main
    extern _scanf
    extern _printf

_main:
    push ebx		; Kayýtçýlarý yýðýna koy
    push ecx
    push mesaj1
    call _printf
    add esp, 4		; Yýðýn göstergesi son girileni görmesin
    push tamsayý1		; Tamsayý1 adresini yýðýna koy
    push girdiBiçimi		; Girdi biçimini yýðýna koy
    call _scanf		; Çaðýrma yýðýný tersten okur
    add esp, 8		; Yýðýn göstergesi son 2 girileni görmesin
    push mesaj2
    call _printf
    add esp, 4		; Yýðýn göstergesi son girileni görmesin
    push tamsayý2		; Tamsayý2 adresini yýðýna koy
    push girdiBiçimi		; Girdi biçimini yýðýna koy
    call _scanf		; Çaðýrma yýðýný tersten okur
    add esp, 8		; Yýðýn göstergesi son 2 girileni görmesin

    mov ebx, dword [tamsayý1]
    mov ecx, dword [tamsayý2]
    add ebx, ecx		; 2 tamsayýyý topla
    push ebx
    push çýktýBiçimi
    call _printf		; Toplam sonucu ekrana yansýt
    add esp, 8		; Yýðýn göstergesi son 2 girileni görmesin
    pop ecx			; Kayýtçýlarý yýðýndan temizle
    pop ebx
    ;mov eax, 0 ; Hata yok
    ret