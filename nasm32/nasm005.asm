; -------------------------------------------------------------------------------------------------------------
; nasm005.asm: Komut satýrýndan girilen tamsayý x^y sonucunu veren örnek.
;
; nasm -fwin32 nasm005.asm
; gcc -m32 nasm005.obj
; ------------------------------------------------------------------------------------------------------------

    global _main
    extern _atoi		; komut satýrýndan girileni tamsayýya çeviren C fonksiyonu
    extern _printf		; sonucu ekrana yazdýran C fonksiyonu

	section .data
    Biçimleme db "Sonuç=%d", 10, 0
    HatalýArgümanSayýsý db "Eksiksiz fazlasýz iki tamsayý deðer girmelisiniz...", 10, 0
    NegatifÜsHatasý: db "Üs negatif olamaz...", 10, 0

	section .text
_main:
    push ebx		; kullanýlacak kayýtçýlarý yýðýna koy
    push esi
    push edi

    mov eax, [esp+16]		; argc (komut satýrý argüman sayýsýný/counter taþý)
    cmp eax, 3		; tam 2 argüman olmalý (prg.ad'la beraber 3)
    jne hata1		; eþit deðilse hata1'e atla

    mov ebx, [esp+20]		; argv (komut satýrý argümanlarýný/value taþý)
    push dword [ebx+4]	; argv [1] (ilk argümaný yýðýna koy: temel=x, argv[0] prg.adý)
    call _atoi		; dizgeden tamsayýya çevir
    add esp, 4
    mov esi, eax		; x'i esi'ye taþý
    push dword [ebx+8]	; argv [2] (ikinci argümaný yýðýna koy: üs=y)
    call _atoi		; dizgeden tamsayýya çevir
    add esp, 4
    cmp eax, 0		; üs'ü 0'la kýyasla
    jl hata2			; negatifse hata2'ye atla
    mov edi, eax		; y'yi edi'ye taþý

    mov eax, 1		; eax = 1
kontrol:
    test edi, edi		; edi içeriði sýfýrsa flag=0
    jz sonucuYaz			; tamamlandý
    imul eax, esi		; eax = eax * esi
    dec edi			; edi üs defa esi kendisiyle çarpýlacak
    jmp kontrol
sonucuYaz:					; print report on success
    push eax
    push Biçimleme
    call _printf
    add esp, 8
    jmp tamamlandý
hata1:			; argüman sayýsý hatasýný yansýt
    push HatalýArgümanSayýsý
    call _printf
    add esp, 4
    jmp tamamlandý
hata2:			; üs deðerin negatif girilme hatasýný yansýt
    push NegatifÜsHatasý
    call _printf
    add esp, 4
tamamlandý:		; saklanan kayýtçýlarý filo çýkar/sil
    pop edi
    pop esi
    pop ebx
    ret			; programý sonlandýr