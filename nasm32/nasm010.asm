; nasm010.asm: Harici dosya rutinleriyle ekrana mesaj yansýtma örneði.
;
; nasm -fwin32 nams010.asm
; gcc -m32 nasm019.obj
;--------------------------------------------------------------------------------------------------------------------
			; Ekran Mesajý, 32 bit
    SIFIR EQU 0		; Ýlk deðerli sabitler
    STD_ÇIKTI_YÖNETÝMÝ EQU -11

    extern _GetStdHandle@4	; Harici rutinlerin ithali
    extern _WriteFile@20
    extern _ExitProcess@4

    global _main		; Programa giriþ noktasýnýn ihracý

	section .data	; Veri bölümündeki ilk deðerli deðiþkenler
    Mesaj db "Ekran Mesajý 32 (uzunluðu kendisi hesaplamakta)", 0Dh, 0Ah
    MesajýnUzunluðu  EQU $ - Mesaj

	section .bss	; Ýlk deðersiz deðiþkenler bölümü
    StardartYönetim resd 1
    Yazýldý resd 1

	section .text	; Kodlama bölümü
_main:
    push  STD_ÇIKTI_YÖNETÝMÝ
    call  _GetStdHandle@4
    mov dword [StardartYönetim], EAX

    push SIFIR		; 5.nci parametre
    push Yazýldý		; 4.ncü parametre
    push MesajýnUzunluðu	; 3.ncü parametre
    push Mesaj		; 2.nci parametre
    push dword [StardartYönetim] ; 1.nci parametre
    call _WriteFile@20	; Çýktýya disk dosyasýna yönlendirmek istersen ">" kullan

    push  SIFIR
    call  _ExitProcess@4