; pcasm2a.asm: Tamsay� �arpma ve b�lmeler �rne�i.
;
; nasm -fwin32 pcasm2a.asm
; gcc pcasm2a.obj pcasm.c asm_io.obj -o pcasm2a.exe
; pcasm2a
;-------------------------------------------------------------------------------------------------------------
;
; 2'nin tamlay�c�s� say�n�n tersine 1 ekleyerek negatifini bulur, hesaplamalarda ta�an at�l�r.
; mul kaynak ==>eax *= kaynak
; AX = AL*kaynak; yada DX:AX = AX*kaynak; yada EDX:EAX = EAX*kaynak
; imul hedef, kaynak ==>hedef *= kaynak1
; imul hedef, kaynak1, kaynak2 ==>hedef = kaynak1 * kaynak2
; div ve idiv de ayn� �ekildedir.
;-------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"	; extern'lerin tan�m dosyas�

	segment .data	; ��kt�ya yans�t�lan ilkde�erli mesajlar
    verigiri�Mesaj� db "Bir tamsay� girin: ", 0
    karesiMesaj� db "Karesi = ", 0
    k�p�Mesaj� db "K�p� = ", 0
    k�p�25Mesaj� db "K�p * 25 = ", 0
    k�pB�l�m100Mesaj� db "K�p / 100 = ", 0
    k�pKalan100Mesaj� db "K�p /100 kalan� = ", 0
    kalan�nNegatifiMesaj� db "Kalan�n negatifi = ", 0

	segment .bss	; �lkde�ersiz de�i�ken-ler
    okunande�er resd 1

	segment .text	; Kodlama b�l�m�
    global  _esas_kodlama	; pcasm.c 'den �a�r�lan fonksiyon ad�
_esas_kodlama:
    enter 0,0		; Kurulum rutini
    pusha

    mov eax, verigiri�Mesaj�
    call yaz_dizge
    call oku_tms
    mov [okunande�er], eax
    imul eax		; Kare: edx:eax = eax * eax
    mov ebx, eax
    mov eax, karesiMesaj�
    call yaz_dizge
    mov eax, ebx
    call yaz_tms
    call yaz_hi�		; Altsat�ra ge�
    ;;mov ebx, eax
    imul ebx, [okunande�er]	; K�p: ebx *= [okunande�er]
    mov eax, k�p�Mesaj�
     call yaz_dizge
    mov eax, ebx
    call yaz_tms
    call yaz_hi�
    imul ecx, ebx, 25		; K�p*25: ecx = ebx * 25
    mov eax, k�p�25Mesaj�
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hi�
    mov eax, ebx
    ;;cdq			; Veri kay�t��s� i�aretini ilkde�erle
    mov ecx, 100		; Anl�k de�ere b�l�nm�yor (idiv 100)
    idiv ecx			; edx:eax /= ecx (B�l�m sonucu eax, kalan� da edx'de)
    mov ecx, eax		; B�l�m sonucunu ecx'ye kopyala
    mov eax, k�pB�l�m100Mesaj�
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hi�
    mov eax, k�pKalan100Mesaj�
    call yaz_dizge
    mov eax, edx
    call yaz_tms
    call yaz_hi�
    neg edx		; Kalan� negatifler
    mov eax, kalan�nNegatifiMesaj�
    call yaz_dizge
    mov eax, edx
    call yaz_tms
    call yaz_hi�

    popa			; Sonland�rma i�lemleri, d�n�� adresini y���ndan al
    ;;mov eax, 0
    leave
    ret			; �a��ran C'ye d�n��