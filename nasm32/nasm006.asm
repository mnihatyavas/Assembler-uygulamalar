; -------------------------------------------------------------------------------------------------------------------
; nasm006.asm: Komut sat�r�ndan girilecek de�erlerin ortalamas�n� bulma �rne�i.
;
; Girilen -+ tamsay�lar�n 15 k�s�ratl� kayan noktal� ortalama ��kt�s�n� yans�t�r.
; nasm -fwin32 nasm006.asm
; gcc -m32 nasm006.obj -o nasm006.exe
; nasm006 12 34 56 -7
; Ortalama=23.750000000000000
; nasm006 12 33 56 -7 13
; Ortalama=21.399999999999999 ; 21.4 de�il!
; --------------------------------------------------------------------------------------------------------------------

    global _main
    extern _printf
    extern _atoi	; dizgeden tamsay�ya �eviren C fonksiyonu

	section .text
_main:
    mov ecx, [esp+4]		; argc, komut sat�r� arg�man say�s�/sayac�
    dec ecx			; 0 endeksli prorgam ad�n� dahil etme
    jz de�erGirilmedi		; e�er ecx saya� de�eri s�f�rsa hi� arg�man girilmemi�tir, paragrafa atla
    mov [saya�], ecx		; ecx de�erini saya� de�i�kene ta��
    mov edx, [esp+8]		; arg�manlar� edx data kay�t��ya ta��
topla:
    push ecx		; sayac� y���na koy
    push edx		; datay� y���na koy
    push dword [edx+ecx*4]	; arg�man�n ilk saya� endekslisini y���na koy
    call _atoi		; eax toplay�c� ilk arg�man�n tamsay� de�erine sahip
    add esp, 4		; g�stergeyi bir ileriye art�r
    pop edx		; y���ndaki data kayd�n� sil
    pop ecx			; y���ndaki saya� kayd�n� sil
    add [toplam], eax		; ilk tamsay� arg�man� toplam de�i�kenine ekle
    dec ecx			; toplam arg�man sayac�n� bir d���r
    jnz topla		; saya� hen�z s�f�rlanmam��sa topla paragraf�na giderek i�lemleri tekrarla
ortala:			; saya� s�f�rlanm��sa, toplanacak arg�man kalmam��t�r
    fild dword [toplam]		; toplam'� matematik e�i�lemci kay�t��s�na (ST0) al
    fild dword [saya�]		; saya�'� da (ST1) al
    fdivp st1, st0		; toplam / saya� hesapla
    sub esp, 8		; sonucu aktaracak y���n g�stergesini ayarla
    fstp qword [esp]		; sonucu "push" sakla
    push bi�imle		;  bi�imle ��kt� format�n� y���na koy
    call _printf		; ortalamay� ekrana yazd�r
    add esp, 12		; g�stergeyi art�r (4 bytes bi�imle i�in, 8 bytes ortalama i�in)
    ret			; program� sonland�r

de�erGirilmedi:
    push hata		; hata a��klamas�n� y���na koy
    call _printf		; hata'y� ekrana yans�t
    add esp, 4
    ret			; program� sonland�r

	section	.data
saya�:	dd	0
toplam:	dd	0
bi�imle:	db	"Ortalama=%.15f", 10, 0
hata:	db	"Ortalamas� al�nacak komut sat�r� arg�manlar� girilmedi", 10, 0