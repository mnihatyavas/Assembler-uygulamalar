; pcasm2a.asm: Tamsayý çarpma ve bölmeler örneði.
;
; nasm -fwin32 pcasm2a.asm
; gcc pcasm2a.obj pcasm.c asm_io.obj -o pcasm2a.exe
; pcasm2a
;-------------------------------------------------------------------------------------------------------------
;
; 2'nin tamlayýcýsý sayýnýn tersine 1 ekleyerek negatifini bulur, hesaplamalarda taþan atýlýr.
; mul kaynak ==>eax *= kaynak
; AX = AL*kaynak; yada DX:AX = AX*kaynak; yada EDX:EAX = EAX*kaynak
; imul hedef, kaynak ==>hedef *= kaynak1
; imul hedef, kaynak1, kaynak2 ==>hedef = kaynak1 * kaynak2
; div ve idiv de ayný þekildedir.
;-------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"	; extern'lerin taným dosyasý

	segment .data	; Çýktýya yansýtýlan ilkdeðerli mesajlar
    verigiriþMesajý db "Bir tamsayý girin: ", 0
    karesiMesajý db "Karesi = ", 0
    küpüMesajý db "Küpü = ", 0
    küpü25Mesajý db "Küp * 25 = ", 0
    küpBölüm100Mesajý db "Küp / 100 = ", 0
    küpKalan100Mesajý db "Küp /100 kalaný = ", 0
    kalanýnNegatifiMesajý db "Kalanýn negatifi = ", 0

	segment .bss	; Ýlkdeðersiz deðiþken-ler
    okunandeðer resd 1

	segment .text	; Kodlama bölümü
    global  _esas_kodlama	; pcasm.c 'den çaðrýlan fonksiyon adý
_esas_kodlama:
    enter 0,0		; Kurulum rutini
    pusha

    mov eax, verigiriþMesajý
    call yaz_dizge
    call oku_tms
    mov [okunandeðer], eax
    imul eax		; Kare: edx:eax = eax * eax
    mov ebx, eax
    mov eax, karesiMesajý
    call yaz_dizge
    mov eax, ebx
    call yaz_tms
    call yaz_hiç		; Altsatýra geç
    ;;mov ebx, eax
    imul ebx, [okunandeðer]	; Küp: ebx *= [okunandeðer]
    mov eax, küpüMesajý
     call yaz_dizge
    mov eax, ebx
    call yaz_tms
    call yaz_hiç
    imul ecx, ebx, 25		; Küp*25: ecx = ebx * 25
    mov eax, küpü25Mesajý
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hiç
    mov eax, ebx
    ;;cdq			; Veri kayýtçýsý iþaretini ilkdeðerle
    mov ecx, 100		; Anlýk deðere bölünmüyor (idiv 100)
    idiv ecx			; edx:eax /= ecx (Bölüm sonucu eax, kalaný da edx'de)
    mov ecx, eax		; Bölüm sonucunu ecx'ye kopyala
    mov eax, küpBölüm100Mesajý
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hiç
    mov eax, küpKalan100Mesajý
    call yaz_dizge
    mov eax, edx
    call yaz_tms
    call yaz_hiç
    neg edx		; Kalaný negatifler
    mov eax, kalanýnNegatifiMesajý
    call yaz_dizge
    mov eax, edx
    call yaz_tms
    call yaz_hiç

    popa			; Sonlandýrma iþlemleri, dönüþ adresini yýðýndan al
    ;;mov eax, 0
    leave
    ret			; Çaðýran C'ye dönüþ