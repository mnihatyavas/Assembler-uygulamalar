; pcasm4c.asm: Girilen �oklu tamsay�lar�n toplam�n� sunan altprogramlar �rne�i.
;
; nasm -fwin32 pcasm4c.asm
; gcc -m32 pcasm4c.obj pcasm.c asm_io.obj (-o pcasm4c.exe)
;----------------------------------------------------------------------------------------------------------------------------------------------
;
; Genel kabul, altprograma CALL ile girilmesi ve RET ile d�n�lmesidir.
; Parametreler CALL �ncesi y���na sokulur, altprogramda de�erleri de�i�tirilecekse y���ndaki adresleri
; kullan�l�r, de�erleri de�il. De�erler dword'den farkl�ysa y���na sokulmadan �nce dword'e �evrilir.
;----------------------------------------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"

	segment .data
    toplam dd 0

	segment .bss
    tamsay� resd 1

; // C kodlamas�
; i = 1;
; toplam = 0;
; while (get_int (i, &n), n != 0 ) {
;     toplam += n;
;     i++;
; } // while sonu...
; print (toplam);

	segment .text
    global  _esas_kodlama
_esas_kodlama:
    enter 0, 0
    pusha

    mov edx, 1		; edx = i kar��l���d�r
d�ng�:
    push edx		; i y���na saklan�r
    push dword tamsay�	; tamsay� de�i�ken adresi y���na saklan�r
    call tamsay�_oku
    add esp, 8		; i ve &tamsay� y���ndan silinir
    mov eax, [tamsay�]
    cmp eax, 0
    je d�ng�_sonu
    add [toplam], eax		; toplam += tamsay�
    inc edx
    jmp short d�ng�
d�ng�_sonu:
    push dword [toplam]	; toplam de�er y���na sokulur
    call toplam�_yaz
    pop ecx			;  [toplam] y���ndan silinir

    popa
    leave
    ret

; Altprogram: tamsay�_oku
; Y���ndaki parametreler
;       tamsay� adedi, i (konumu [ebp + 12])
;       tamsay�'n�n adresi (konumu [ebp + 8])

	segment .data
Verigiri�Mesaj� db ") Bir tamsay� girin (��k��: 0): ", 0

	segment .text
tamsay�_oku:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 12]
    call yaz_tms
    mov eax, Verigiri�Mesaj�
    call yaz_dizge
    call oku_tms
    mov ebx, [ebp + 8]
    mov [ebx], eax
    pop ebp
    ret

; Altprogram: toplam�_yaz
; Parametreler:
;       yazd�r�lacak toplam (konumu [ebp+8])

	segment .data
��kt�Mesaj� db " adet girilen tamsay�lar�n toplam�: ", 0

	segment .text
toplam�_yaz:
    push ebp
    mov ebp, esp
    dec edx
    mov eax, edx
    call yaz_tms
    mov eax, ��kt�Mesaj�
    call yaz_dizge
    mov eax, [ebp+8]
    call yaz_tms
    call yaz_hi�
    pop ebp
    ret