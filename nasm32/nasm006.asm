; -------------------------------------------------------------------------------------------------------------------
; nasm006.asm: Komut satýrýndan girilecek deðerlerin ortalamasýný bulma örneði.
;
; Girilen -+ tamsayýlarýn 15 küsüratlý kayan noktalý ortalama çýktýsýný yansýtýr.
; nasm -fwin32 nasm006.asm
; gcc -m32 nasm006.obj -o nasm006.exe
; nasm006 12 34 56 -7
; Ortalama=23.750000000000000
; nasm006 12 33 56 -7 13
; Ortalama=21.399999999999999 ; 21.4 deðil!
; --------------------------------------------------------------------------------------------------------------------

    global _main
    extern _printf
    extern _atoi	; dizgeden tamsayýya çeviren C fonksiyonu

	section .text
_main:
    mov ecx, [esp+4]		; argc, komut satýrý argüman sayýsý/sayacý
    dec ecx			; 0 endeksli prorgam adýný dahil etme
    jz deðerGirilmedi		; eðer ecx sayaç deðeri sýfýrsa hiç argüman girilmemiþtir, paragrafa atla
    mov [sayaç], ecx		; ecx deðerini sayaç deðiþkene taþý
    mov edx, [esp+8]		; argümanlarý edx data kayýtçýya taþý
topla:
    push ecx		; sayacý yýðýna koy
    push edx		; datayý yýðýna koy
    push dword [edx+ecx*4]	; argümanýn ilk sayaç endekslisini yýðýna koy
    call _atoi		; eax toplayýcý ilk argümanýn tamsayý deðerine sahip
    add esp, 4		; göstergeyi bir ileriye artýr
    pop edx		; yýðýndaki data kaydýný sil
    pop ecx			; yýðýndaki sayaç kaydýný sil
    add [toplam], eax		; ilk tamsayý argümaný toplam deðiþkenine ekle
    dec ecx			; toplam argüman sayacýný bir düþür
    jnz topla		; sayaç henüz sýfýrlanmamýþsa topla paragrafýna giderek iþlemleri tekrarla
ortala:			; sayaç sýfýrlanmýþsa, toplanacak argüman kalmamýþtýr
    fild dword [toplam]		; toplam'ý matematik eþiþlemci kayýtçýsýna (ST0) al
    fild dword [sayaç]		; sayaç'ý da (ST1) al
    fdivp st1, st0		; toplam / sayaç hesapla
    sub esp, 8		; sonucu aktaracak yýðýn göstergesini ayarla
    fstp qword [esp]		; sonucu "push" sakla
    push biçimle		;  biçimle çýktý formatýný yýðýna koy
    call _printf		; ortalamayý ekrana yazdýr
    add esp, 12		; göstergeyi artýr (4 bytes biçimle için, 8 bytes ortalama için)
    ret			; programý sonlandýr

deðerGirilmedi:
    push hata		; hata açýklamasýný yýðýna koy
    call _printf		; hata'yý ekrana yansýt
    add esp, 4
    ret			; programý sonlandýr

	section	.data
sayaç:	dd	0
toplam:	dd	0
biçimle:	db	"Ortalama=%.15f", 10, 0
hata:	db	"Ortalamasý alýnacak komut satýrý argümanlarý girilmedi", 10, 0