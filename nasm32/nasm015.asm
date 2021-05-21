; nasm05.asm: Komut satýrýndan girilen 2 tamsayýnýn toplamýný yansýtma örneði.
;
; nasm -fwin31 nasm015.asm
; gcc -m32 nasm015.obj -o nasm015.exe
; nasm015 24 76
;---------------------------------------------------------------------------------------------------------------------

	SECTION .data
    çýktýBiçimi: db "Komutsatýrýndan girilen 2 +tamsayýnýn toplamý: %d", 0	; Altsatýr 0 sonlandýrýcý

	SECTION .text
    global _main
    extern _printf

karakterdenTamsayýya:	; Komut satýrýndan yapýlan karakter giriþini tamsayýya çeviriyoruz
    push ebx	; Kayýtçý adresleini yýðýna koy
    push ecx
    mov ebx, eax	; Komut satýrýndan girilen argüman eax'da farzediyoruz
    mov eax, 0

döngü:
    cmp byte [ebx], 0
    je tamamlandý
    mov ecx, 10
    mul ecx		; Çoklu rakam giriþinde önceki hane-ler 10'la çarpýlýp sonrakilerle toplanacak
    mov cl, byte [ebx]
    sub cl, "0"
    add eax, ecx
    inc ebx
    jmp döngü

tamamlandý:
    pop ecx		; Yýðýn boþaltýlsýn
    pop ebx
    ret		; Çaðrýlan adrese geri dönüþ

_main:
    push ebp
    mov ebp, esp
    push ebx	; Kayýtçýlar yýðýna saklansýn
    push ecx
    cmp dword [ebp+8], 3	; Argüman sayýsý 3 deðilse iþlem yapýlmasýn
    jne main_sonu
    mov ebx, [ebp+12]	; Argümanlar temel kayýtçýya
    mov eax, [ebx+4]		; Ýlk tamsayý toplayýcý kayýtçýya
    call karakterdenTamsayýya	; Ýlk argüman karakterden tamsayýya çevrilsin
    mov ecx, eax		; Yýðýn boþaltýlsýn
    mov eax, [ebx+8]		; Ýkinci tamsayý toplayýcýya
    call karakterdenTamsayýya	; 2.argüman tamsayýya çevrilsin
    add eax, ecx		; Her iki tamsayý toplansýn
    push eax
    push çýktýBiçimi
    call _printf		; Sonuç ekrana yazdýrýlsýn
    add esp, 8		; Yýðýn parametreleri silinsin

main_sonu:
    pop ecx			; Kayýtçý ve gösterge geridönüþ adresleri yýðýndan alýnsýn
    pop ebx
    pop ebp
    mov eax, 0		; Hata gösterme
    ret