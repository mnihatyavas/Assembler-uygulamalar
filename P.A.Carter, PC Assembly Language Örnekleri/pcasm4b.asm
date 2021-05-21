; pcas4b.asm: Altprogramlardan otomatik call-pusha/ret-popa ile d�n�lmesi �rne�i.
;
; nasm -fwin32 pcasm4b.asm
; gcc pcasm4b.obj pcasm.c asm_io.obj -o pcasm4b.exe
;---------------------------------------------------------------------------------------------------------------------------
;
; Y���na PUSH ile her eklenen dword adresle ESP y���n g�sterge�i 4 azal�rken, POP ile her ��ker�lan ESP'e 4 ekler.
; push dword 1	; Y���nba�� 1000h adrese 1dw de�eri eklenince ESP=1000h - 0004h = 0FFCh
; push dword 2	; Y���nba�� 1000h adrese 2dw de�eri eklenince ESP=0FFCh-0004h=0FF8h
; push dword 3	; Y���nba�� 1000h adrese 3dw de�eri eklenince ESP=0FF8h-0004h=0FF4h
; pop eax		; LIFO y���ndan son sokulan ��kar�l�nca EAX = 3, ESP=0FF4h+0004h=0FF8h
; pop ebx		; Y���ndan bir �nceki ��kar�l�nca EBX=2, ESP=0FF8h+0004h=0FFCh
; pop ecx		; Y���ndan sonuncu ��kar�l�nca ECX=1, ESP0FFCh+0004h=1000h
;
; PUSHA ile EAX, EBX, ECX, EDX, ESI, EDI, EBP kay�t��lar� hepten sokulur,
; POPA ile ise hepten ��kar�l�r.
; CALL tamsay�_okuma_altprogram� ile otomatikmen PUSHA ile y���nlar sokulur ve gidilen altprogramdaki ilk
; RET ile de otomatikmen POPA ��kar�l�p d�n�� adresi bulunur. �ayet
; tamsay�_okuma_altprogram�:
; call oku_tms
; mov [ebx], eax
; push eax	; Otomatik y���na yeni adres soku�u
; ret		; Otomatik POPA ile gerid�n��� bulamayacak...
;---------------------------------------------------------------------------------------------------------------------------

%include "asm_io.inc"

	segment .data
    Giri�Mesaj�1 db "�lk tamsay�y� girin: ", 0		; 0 mesaj sonunu g�sterir
    Giri�Mesaj�2 db "�kinci tamsay�y� girin: ", 0
    ��k��Mesaj�1 db "Girdikleriniz: ", 0
    ��k��Mesaj�2 db " ve ", 0
    ��k��Mesaj�3 db " olup toplamlar�: ", 0

	segment .bss
    tamsay�1 resd 1		; 1dw'l�k tamsay� saklama de�i�kenleri
    tamsay�2 resd 1

	segment .text
    global  _esas_kodlama
_esas_kodlama:
    enter 0,0
    pusha

    mov eax, Giri�Mesaj�1
    call yaz_dizge
    mov ebx, tamsay�1
    call tamsay�_okuma_altprogram�
    mov eax, Giri�Mesaj�2
    call yaz_dizge
    mov ebx, tamsay�2
    call tamsay�_okuma_altprogram�

    mov eax, [tamsay�1]
    add eax, [tamsay�2]
    mov ebx, eax

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
    call yaz_hi�

    popa
    ;;mov eax, 0
    leave                     
    ret

;---------------------------------------------------------------------------------------------------------------------------
tamsay�_okuma_altprogram�:
    call oku_tms
    mov [ebx], eax	; Okunan tamsay� ebx'teki tamsay�1/2 de�i�kenlerine konur
    ret