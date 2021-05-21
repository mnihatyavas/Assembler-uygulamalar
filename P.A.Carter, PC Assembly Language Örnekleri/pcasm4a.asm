; pcasm4a.asm: Altprogramlarla iki tamsay�n�n toplam�n�n hesaplanmas� �rne�i.
;
; nasm -fwin32 pcasm4a.asm
; gcc pcasm4a.obj pcasm.c asm_io.obj -o pcasm4a.exe
;---------------------------------------------------------------------------------------------------------------------------
;
; Dolays�z adresleme
; mov ax, [Data]	; Data de�eri ax'e aktar�l�r (ax = Data)
; mov ebx, Data	; Data adresi ebx'e aktar�l�r (ebx = &Data)
; mov ax, [ebx]	; EBX de�eri ax'e aktar�l�r (ax = *ebx)
;---------------------------------------------------------------------------------------------------------------------------

%include "asm_io.inc"

	segment .data
    Giri�Mesaj�1 db "Bir tamsay� girin: ", 0
    Giri�Mesaj�2 db "Bir tamsay� daha girin: ", 0
    ��k��Mesaj�1 db "Girdikleriniz: ", 0
    ��k��Mesaj�2 db " ve ", 0
    ��k��Mesaj�3 db " olup, toplamlar�: ", 0

	segment .bss
    tamsay�1 resd 1		; double tipli tamsay� giri�leri
    tamsay�2 resd 1

	segment .text
    global  _esas_kodlama
_esas_kodlama:
    enter 0,0		; Ba�latma rutini
    pusha

    mov eax, Giri�Mesaj�1
    call yaz_dizge
    mov ebx, tamsay�1	; tamsay�1 adresi ebx'e saklan�r
    mov ecx, d�n1		; d�n1 adresi ecx'e saklan�r
    jmp short tamsay�_okuma_altprogram�	; �lk tamsay�y� okuma altprogram�na gidilir
d�n1:
    mov eax, Giri�Mesaj�2
    call yaz_dizge
    mov ebx, tamsay�2
    ;;mov ecx, $ + 7		; ecx = mevcut_adres + 7, yada
    mov ecx, d�n2
     jmp short tamsay�_okuma_altprogram�
d�n2:
    mov eax, [tamsay�1]
    add eax, [tamsay�2]
    mov ebx, eax
;
; Sonu� bir seri mesajlarla yazd�r�l�r
;
    mov eax, ��k��Mesaj�1
    call yaz_dizge
    mov eax, [tamsay�1]
    call yaz_tms
    mov eax, ��k��Mesaj�2
    call yaz_dizge
    mov eax, [tamsay�2]
    call yaz_tms
    mov eax, ��k��Mesaj�3
    call yaz_dizge
    mov eax, ebx
    call yaz_tms
    call yaz_hi�		; Altsat�ra ge�

    popa			; Sonland�rma rutini
    mov eax, 0
    leave
    ret			; �a��ran C'ye d�n��
;
; tamsay�_okuma_altprogram�
; Parametreler:
; ebx - okunan tamsay�n�n i�ine konaca�� dword adresi
; ecx - geri d�n�lecek etiketin adresi
; Not: Geri d�nerken eax i�eri�i kaybolaca��ndan ebx'e aktar�l�r
tamsay�_okuma_altprogram�:
    call oku_tms
    mov [ebx], eax		; Okunan tamsay� bellek kay�t��s� ebx'e konur
    jmp ecx			; �a��ran kod alt�na (d�n1 etiketi) gerid�n�l�r