; asmtutor18.asm: �lk 100 say�daki ��e, be�e, hem �� hem be�e b�l�nenlerin tespiti �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 1, 2, ��, 4, Be�, ��, 7, 8, ��, Be�, 11, ��, 13, 14, ��Be�, 16, 17, ��, 19, Be�, ��, 22, 23, ��, Be�, 26, ��, 28, 29, ��Be�, 31, 32, ��, 34, Be�, ��, 37, 38, ��, Be�, 41, ��, 43, 44, ��Be�, 46, 47, ��, 49, Be�, ��, 52, 53, ��, Be�, 56, ��, 58, 59, ��Be�, 61, 62, ��, 64, Be�, ��, 67, 68, ��, Be�, 71, ��, 73, 74, ��Be�, 76, 77, ��, 79, Be�, ��, 82, 83, ��, Be�, 86, ��, 88, 89, ��Be�, 91, 92, ��, 94, Be�, ��, 97, 98, ��, Be�, 
;----------------------------------------------------------------------------------------------------------------------------------
; ===18.��be� Oyunu===
; Program 1'den 100'e ECX sayac� art�r�p, ��e b�l�nyorsa ��, be�e b�l�n�yorsa Be�, herikisine b�l�n�yorsa
; ��Be�, de�ilse rakam�n kendisini yazacak.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    �� db "��", 0h
    Be� db "Be�", 0h
    Aral�k db ", ", 0h

	SECTION .text
    global _start
_start:
    mov edi, 0	; .��_kontrolu ikili de�i�keninin ilkde�eri
    mov esi, 0	; .be�_kontrolu ikili de�i�keninin ilkde�eri
    mov ecx, 0	; 100'l�k sayac�n ilkde�eri
birsonraki_say�:
    inc ecx		; kontrol edilecek say�lar sayac� birart�r�l�r
.��_kontrolu:
    mov edx, 0	; B�l�mden kalan� tutacak
    mov eax, ecx	; Saya�taki say� b�l�m i�in EAX'a ta��n�r
    mov ebx, 3	; B�len 3 EBX'e ta��n�r
    div ebx		; EAX /=EBX
    mov edi, edx	; B�l�m kalan� EDI'ye ta��n�r
    cmp edi, 0	; Kalan s�f�r m�?
    jne .be�_kontrolu	; S�f�r de�ilse .be�_kontrolu'na atla
    mov eax, ��	; Kalan s�f�rsa ��e b�l�n�r mesaj� yans�t�lacak
    call dyaz	; "��" yaz�lacak
.be�_kontrolu:
    mov edx, 0	; B�l�m kalan� kay�t��s� s�f�rlan�r
    mov eax, ecx	; Akt�el say� tekrar EAX'a aktar�l�r
    mov ebx, 5	; B�len 5 EBX'e ta��n�r
    div ebx		; EAX /=EBX
    mov esi, edx	; Kalan ESI'ye ta��n�r
    cmp esi, 0	; Kalan s�f�r m�?
    jne .tamsay�_kontrolu	; S�f�r de�ilse .tamsay�_kontrolu'na atla
    mov eax, Be�	; S�f�rsa be�e b�l�n�r mesaj� yaz�lacak
    call dyaz	; "Be�" yaz�lacak
.tamsay�_kontrolu:
;tamsay�_kontrolu:
    cmp edi, 0	; EDI 3'e b�l�m kalan�n� tutmakta
    je .devam	; "��" yazm��san say� yaz�lmayacak, atla
    cmp esi, 0	; ESI 5'e b�l�m kalan�n� tutmakta
    je .devam	; "Be�" yazm��san say� yaz�lmayacak, atla
    mov eax, ecx	; Saya�taki akt�el say� yaz�lacak
    call tyaz	; Say�'y� yaz
.devam:
    ;mov eax, 0Ah	; Altsat�ra ge�ilecek
    ;push eax	; Y���na koy
    ;mov eax, esp	; Y���n g�stergesini (altsat�r bilgi adresini) EAX'e ta��
    mov eax, Aral�k
    call dyaz
    ;pop eax	; Y���na konulan� sil
    cmp ecx, 100	; Saya�=100?
    jne birsonraki_say�	; Hen�z de�ilse tekrar d�ng� ba��na atla
    call son