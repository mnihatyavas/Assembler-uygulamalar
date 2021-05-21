; ------------------------------------------------------------------------------------------------------------
; nasm004.asm: Komut satýrý kelimelerini ekrana altalta yansýtan örnek.
;
; nasm -fwin32 nasm004.asm
; gcc -m32 nasm004.obj
; a M.Nihat Yavaþ Yeþilyurt-Malatya Toroslar - Mersin
; --------------------------------------------------------------------------------------------------------------

    global _main
    extern _printf

	section .data
    Biçimle db "%s", 10, 0

	section .text
_main:
    mov ecx, [esp+4]	; arg0: komut satýrýndaki toplam argüman sayýsý
    mov edx, [esp+8]	; arg1: ilk argüman endeksi
döngü:
    push ecx	; _printf yazdýrýrken kayýtçýlarý yýðýna sakla
    push edx

    push dword [edx]	; ekrana yansýtýlacak aktüel argüman
    push Biçimle 	; %s: string/dizge formatý
    call _printf
    add esp, 8	; ilk 2 parametreyi sil

    pop edx	; _prinf'in kullandýðý kayýtçýlarý yýðýndan al
    pop ecx

    add edx, 4	; bir sonraki endeksi göster
    dec ecx		; toplam argüman sayýsýný bir düþür
    jnz döngü	; ecx sýfýr deðilse döngüye devam et

    ret