; pcasm5a.asm: Y�zl�k tersten s�ral� tamsay�lar�n istenen eleman�n� ve onluk i�eri�ini g�sterme �rne�i.
;
; nasm -fwin32 pcasm5a.asm
; gcc -m32 pcasm5a.obj pcasm5a.c asm_io.obj
;---------------------------------------------------------------------------------------------------------------------------------

; Dizi tan�mlama �rnekleri:
; segment .data
; 10 dd-DataDoubleword elemanl� dizi ve ilk de�erleri 1,2,..,10
; a1 dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
; 10 dw-DataWord elemanl� dizi, ilk de�erleri 0
; a2 dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
; �ncekini TIMES ile tan�mlama
; a3 times 10 dw 0
; 300 db-DataByte elemanl� dizi, 200 ilk de�erleri 0, 100 ilk de�erleri 1
; a4 times 200 db 0 times 100 db 1
;
; segment .bss
; 10 elemanl� dw dizisi, ilkde�ersiz
; a5 resd 10
; 100 elemanl� w dizisi, ilkde�ersiz
; a6 resw 100
;
; dizi1 db 5, 4, 3, 2, 1		; byte dizisi
; dizi2 dw 5, 4, 3, 2, 1	; kelime dizisi
; Dizilerle �rnekler:
; mov al, [dizi1]		; al = dizi1[0]
; mov al, [dizi1 + 1]		; al = dizi1[1]
; mov [dizi1 + 3], al		; dizi1[3] = al
; mov ax, [dizi2]		; ax = dizi2[0]
; mov ax, [dizi2 + 2]		; ax = dizi2[1] (dizi2[2] DE��L!)
; mov [dizi2 + 6], ax		; dizi2[3] = ax
; mov ax, [dizi2 + 1]		; ax=?? hata
;
; dizi1 elemanlar�n� toplama:
; mov ebx, dizi1		; ebx = dizi1'in adresi
; mov dx, 0		; dx toplam� saklayacak
; mov ah, 0
; mov ecx, 5
; d�ng�:
; mov al, [ebx]		; al = *ebx
; add dx, ax		; dx += ax (al de�il!)
; inc ebx			; bx++
; loop d�ng�
;
; Ayn� topam�n 2.alternatifi:
; mov ebx, dizi1		; ebx = dizi1'in adresi
; mov dx, 0		; dx toplam� saklayacak
; mov ecx, 5
; d�ng�:
; add dl, [ebx]		; dl += *ebx
; jnc sonraki		; JumpNotCarry
; inc dh
; sonraki:
; inc ebx			; bx++
; loop d�ng�
;
; Ayn� toplam�n 3.alternatifi:
; mov ebx, dizi1		; ebx = dizi1'in adresi
; mov dx, 0		; dx toplam� saklayacak
; mov ecx, 5
; d�ng�:
; add dl, [ebx]		; dl += *ebx
; adc dh, 0		; dh += CarryFlag + 0
; inc ebx			; bx++
; loop d�ng�
;
; lea ebx, [4*eax + eax]	; 4*EAX+EAX=5*EAX sonu� de�erini EBX'e y�kler
; _puts: ��kt�dan sonra altsat�r yapar, _printf yapmaz
;---------------------------------------------------------------------------------------------------------------------------------

    %define D�Z�_EBATI 100
    %define ALT_SATIR 10

	segment .data
    ��kt�Mesaj�1 db   "Dizinin ilk 11 eleman� [0-10]:", ALT_SATIR, 0
    ��kt�Mesaj�2 db "Dizinin %d.nci eleman de�eri: %d", ALT_SATIR, 0
    ��kt�Mesaj�3 db ALT_SATIR, "Dizinin son 21 eleman� [80-100]:", ALT_SATIR, 0
    GirdiMesaj� db ALT_SATIR, "G�rmek istedi�in dizi eleman endeksini gir [0-100]: ", 0
    GirdiBi�imi db "%d", 0
    ��kt�Bi�imi db "%5d %5d", ALT_SATIR, 0

	segment .bss
    dizi resd D�Z�_EBATI

	segment .text
    extern _printf, _scanf, _veri_kontrolu	; _puts
    global  _esas_kodlama
_esas_kodlama:
    enter 4, 0		; EBP - 4'teki yerel de�i�ken
    push ebx
    push esi

; 100 elemanl� diziye ilk de�erlerini atama: 100, 99, 98, 97, ..., 0
    mov ecx, D�Z�_EBATI
    mov ebx, dizi
ba�latma_d�ng�s�:
    mov [ebx], ecx
    add ebx, 4
    loop ba�latma_d�ng�s�	; dec ecx

    push dword ��kt�Mesaj�1	; Dizinin ilk 11 eleman�n� yaz
    call _printf
    ;pop ecx
    push dword 11		; 11 eleman yaz�lacak
    push dword dizi
    call _diziyi_yaz
    ;add     esp, 8

; G�r�lecek dizi eleman endeks giri�i
GirdiMesaj�_d�ng�s�:
    push dword GirdiMesaj�
    call _printf
    ;pop     ecx
    lea eax, [ebp-4]		; eax = girilece�in saklanaca�� yerel de�i�ken adresi
    push eax
    push dword GirdiBi�imi
    call _scanf
    ;add esp, 8
    cmp eax, 1		; eax = scanf d�nen de�eri (tamsay�=1)
    je giri�Tamam
    call _veri_kontrolu
    jmp GirdiMesaj�_d�ng�s�	; Ge�ersiz giri�
giri�Tamam:
    mov esi, [ebp-4]
    push dword [dizi + 4*esi]	; Girilenin dizideki konumu
    push esi
    push dword ��kt�Mesaj�2	; Girilen eleman�n ��kt�lanma mesaj�
    call _printf
    ;add esp, 12

    push dword ��kt�Mesaj�3
    call _printf
    ;pop ecx
    push dword 21		;�stersen son 21 eleman yazal�m
    push dword dizi + 80*4	;  dizi[80]'in adresi
    call _diziyi_yaz
    ;add esp, 8

    pop esi			; �a��ran C'ye gerid�n��
    pop ebx
    ;mov eax, 0
    leave                     
    ret

;  _diziyi_yaz rutini
; C prototipi:
; void diziyi_yaz (const int * a, int n);
; Parametreler:
;   a - (y���nda ebp+8 konum) yazd�r�lacak dizinin g�sterge�i
;   n - (y���nda ebp+12 konum) dizinin yazd�r�lacak ebat�
	segment .text
    global  _diziyi_yaz
_diziyi_yaz:
    enter 0, 0
    push esi
    push ebx

    xor esi, esi		; esi = 0
    mov ecx, [ebp+12]		; ecx = n
    mov ebx, [ebp+8]		; ebx = dizi adresi
yaz_d�ng�s�:
    push ecx
    push dword [ebx + 4*esi]	; push dizi [esi]
    push esi
    push dword ��kt�Bi�imi
    call _printf
    add esp, 12
    inc esi
    pop ecx
    loop yaz_d�ng�s�	; dec ecx

    pop ebx
    pop esi
    leave
    ret