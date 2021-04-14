; ----------------------------------------------------------------------------
; nasm007.asm: Altalta 2^0'den 2^31'e üslü sonuçlarý dökümleyen örnek.
;
;  nasm -fwin32 nasm007.asm
;  gcc -m32 nasm007.obj" -o nasm007.exe
; ----------------------------------------------------------------------------

    extern _printf
    global _main

	section .text
_main:
    push esi	; source index/kaynak-endeks kayýtçýyý yýðýna sakla
    push edi	; destination index/hedef-endeks kayýtçýyý yýðýna sakla

    mov esi, 1	; ilk üs deðerini esi'ye koy
    mov edi, 31	; son üs deðerini edi'ye koy
prgf1:
    push esi	; yazdýrýlacak deðeri yýðýna koy
    push biçimle	; biçimle dizge adresini yýðýna koy
    call _printf	; ekrana yazdýr
    add esp, 8	; _printf'e aktarýlan parametreleri yýðýndan çýkar/sil (göstergeyi atlat)
    add esi, esi	; esi deðerini ikiye katla (1+1=2, 2+2=4, 4+4=8 vb)
    dec edi		; edi sayacýný bir indir (edi=edi-1)
    jnz prgf1	; sonuç sýfýr deðilse prgf1'e git

    pop edi		; yýðýndan edi'yi çýkar/sil
    pop esi		; yýðýndan esi'yi çýkar/sil
    ret		; geridön, programý sonlandýr

biçimle: db "%d", 10, 0