; pcasm4a.asm: Altprogramlarla iki tamsayýnýn toplamýnýn hesaplanmasý örneði.
;
; nasm -fwin32 pcasm4a.asm
; gcc pcasm4a.obj pcasm.c asm_io.obj -o pcasm4a.exe
;---------------------------------------------------------------------------------------------------------------------------
;
; Dolaysýz adresleme
; mov ax, [Data]	; Data deðeri ax'e aktarýlýr (ax = Data)
; mov ebx, Data	; Data adresi ebx'e aktarýlýr (ebx = &Data)
; mov ax, [ebx]	; EBX deðeri ax'e aktarýlýr (ax = *ebx)
;---------------------------------------------------------------------------------------------------------------------------

%include "asm_io.inc"

	segment .data
    GiriþMesajý1 db "Bir tamsayý girin: ", 0
    GiriþMesajý2 db "Bir tamsayý daha girin: ", 0
    ÇýkýþMesajý1 db "Girdikleriniz: ", 0
    ÇýkýþMesajý2 db " ve ", 0
    ÇýkýþMesajý3 db " olup, toplamlarý: ", 0

	segment .bss
    tamsayý1 resd 1		; double tipli tamsayý giriþleri
    tamsayý2 resd 1

	segment .text
    global  _esas_kodlama
_esas_kodlama:
    enter 0,0		; Baþlatma rutini
    pusha

    mov eax, GiriþMesajý1
    call yaz_dizge
    mov ebx, tamsayý1	; tamsayý1 adresi ebx'e saklanýr
    mov ecx, dön1		; dön1 adresi ecx'e saklanýr
    jmp short tamsayý_okuma_altprogramý	; Ýlk tamsayýyý okuma altprogramýna gidilir
dön1:
    mov eax, GiriþMesajý2
    call yaz_dizge
    mov ebx, tamsayý2
    ;;mov ecx, $ + 7		; ecx = mevcut_adres + 7, yada
    mov ecx, dön2
     jmp short tamsayý_okuma_altprogramý
dön2:
    mov eax, [tamsayý1]
    add eax, [tamsayý2]
    mov ebx, eax
;
; Sonuç bir seri mesajlarla yazdýrýlýr
;
    mov eax, ÇýkýþMesajý1
    call yaz_dizge
    mov eax, [tamsayý1]
    call yaz_tms
    mov eax, ÇýkýþMesajý2
    call yaz_dizge
    mov eax, [tamsayý2]
    call yaz_tms
    mov eax, ÇýkýþMesajý3
    call yaz_dizge
    mov eax, ebx
    call yaz_tms
    call yaz_hiç		; Altsatýra geç

    popa			; Sonlandýrma rutini
    mov eax, 0
    leave
    ret			; Çaðýran C'ye dönüþ
;
; tamsayý_okuma_altprogramý
; Parametreler:
; ebx - okunan tamsayýnýn içine konacaðý dword adresi
; ecx - geri dönülecek etiketin adresi
; Not: Geri dönerken eax içeriði kaybolacaðýndan ebx'e aktarýlýr
tamsayý_okuma_altprogramý:
    call oku_tms
    mov [ebx], eax		; Okunan tamsayý bellek kayýtçýsý ebx'e konur
    jmp ecx			; Çaðýran kod altýna (dön1 etiketi) geridönülür