; pcasm5a.asm: Yüzlük tersten sýralý tamsayýlarýn istenen elemanýný ve onluk içeriðini gösterme örneði.
;
; nasm -fwin32 pcasm5a.asm
; gcc -m32 pcasm5a.obj pcasm5a.c asm_io.obj
;---------------------------------------------------------------------------------------------------------------------------------

; Dizi tanýmlama örnekleri:
; segment .data
; 10 dd-DataDoubleword elemanlý dizi ve ilk deðerleri 1,2,..,10
; a1 dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
; 10 dw-DataWord elemanlý dizi, ilk deðerleri 0
; a2 dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
; Öncekini TIMES ile tanýmlama
; a3 times 10 dw 0
; 300 db-DataByte elemanlý dizi, 200 ilk deðerleri 0, 100 ilk deðerleri 1
; a4 times 200 db 0 times 100 db 1
;
; segment .bss
; 10 elemanlý dw dizisi, ilkdeðersiz
; a5 resd 10
; 100 elemanlý w dizisi, ilkdeðersiz
; a6 resw 100
;
; dizi1 db 5, 4, 3, 2, 1		; byte dizisi
; dizi2 dw 5, 4, 3, 2, 1	; kelime dizisi
; Dizilerle örnekler:
; mov al, [dizi1]		; al = dizi1[0]
; mov al, [dizi1 + 1]		; al = dizi1[1]
; mov [dizi1 + 3], al		; dizi1[3] = al
; mov ax, [dizi2]		; ax = dizi2[0]
; mov ax, [dizi2 + 2]		; ax = dizi2[1] (dizi2[2] DEÐÝL!)
; mov [dizi2 + 6], ax		; dizi2[3] = ax
; mov ax, [dizi2 + 1]		; ax=?? hata
;
; dizi1 elemanlarýný toplama:
; mov ebx, dizi1		; ebx = dizi1'in adresi
; mov dx, 0		; dx toplamý saklayacak
; mov ah, 0
; mov ecx, 5
; döngü:
; mov al, [ebx]		; al = *ebx
; add dx, ax		; dx += ax (al deðil!)
; inc ebx			; bx++
; loop döngü
;
; Ayný topamýn 2.alternatifi:
; mov ebx, dizi1		; ebx = dizi1'in adresi
; mov dx, 0		; dx toplamý saklayacak
; mov ecx, 5
; döngü:
; add dl, [ebx]		; dl += *ebx
; jnc sonraki		; JumpNotCarry
; inc dh
; sonraki:
; inc ebx			; bx++
; loop döngü
;
; Ayný toplamýn 3.alternatifi:
; mov ebx, dizi1		; ebx = dizi1'in adresi
; mov dx, 0		; dx toplamý saklayacak
; mov ecx, 5
; döngü:
; add dl, [ebx]		; dl += *ebx
; adc dh, 0		; dh += CarryFlag + 0
; inc ebx			; bx++
; loop döngü
;
; lea ebx, [4*eax + eax]	; 4*EAX+EAX=5*EAX sonuç deðerini EBX'e yükler
; _puts: çýktýdan sonra altsatýr yapar, _printf yapmaz
;---------------------------------------------------------------------------------------------------------------------------------

    %define DÝZÝ_EBATI 100
    %define ALT_SATIR 10

	segment .data
    ÇýktýMesajý1 db   "Dizinin ilk 11 elemaný [0-10]:", ALT_SATIR, 0
    ÇýktýMesajý2 db "Dizinin %d.nci eleman deðeri: %d", ALT_SATIR, 0
    ÇýktýMesajý3 db ALT_SATIR, "Dizinin son 21 elemaný [80-100]:", ALT_SATIR, 0
    GirdiMesajý db ALT_SATIR, "Görmek istediðin dizi eleman endeksini gir [0-100]: ", 0
    GirdiBiçimi db "%d", 0
    ÇýktýBiçimi db "%5d %5d", ALT_SATIR, 0

	segment .bss
    dizi resd DÝZÝ_EBATI

	segment .text
    extern _printf, _scanf, _veri_kontrolu	; _puts
    global  _esas_kodlama
_esas_kodlama:
    enter 4, 0		; EBP - 4'teki yerel deðiþken
    push ebx
    push esi

; 100 elemanlý diziye ilk deðerlerini atama: 100, 99, 98, 97, ..., 0
    mov ecx, DÝZÝ_EBATI
    mov ebx, dizi
baþlatma_döngüsü:
    mov [ebx], ecx
    add ebx, 4
    loop baþlatma_döngüsü	; dec ecx

    push dword ÇýktýMesajý1	; Dizinin ilk 11 elemanýný yaz
    call _printf
    ;pop ecx
    push dword 11		; 11 eleman yazýlacak
    push dword dizi
    call _diziyi_yaz
    ;add     esp, 8

; Görülecek dizi eleman endeks giriþi
GirdiMesajý_döngüsü:
    push dword GirdiMesajý
    call _printf
    ;pop     ecx
    lea eax, [ebp-4]		; eax = girileceðin saklanacaðý yerel deðiþken adresi
    push eax
    push dword GirdiBiçimi
    call _scanf
    ;add esp, 8
    cmp eax, 1		; eax = scanf dönen deðeri (tamsayý=1)
    je giriþTamam
    call _veri_kontrolu
    jmp GirdiMesajý_döngüsü	; Geçersiz giriþ
giriþTamam:
    mov esi, [ebp-4]
    push dword [dizi + 4*esi]	; Girilenin dizideki konumu
    push esi
    push dword ÇýktýMesajý2	; Girilen elemanýn çýktýlanma mesajý
    call _printf
    ;add esp, 12

    push dword ÇýktýMesajý3
    call _printf
    ;pop ecx
    push dword 21		;Ýstersen son 21 eleman yazalým
    push dword dizi + 80*4	;  dizi[80]'in adresi
    call _diziyi_yaz
    ;add esp, 8

    pop esi			; Çaðýran C'ye geridönüþ
    pop ebx
    ;mov eax, 0
    leave                     
    ret

;  _diziyi_yaz rutini
; C prototipi:
; void diziyi_yaz (const int * a, int n);
; Parametreler:
;   a - (yýðýnda ebp+8 konum) yazdýrýlacak dizinin göstergeçi
;   n - (yýðýnda ebp+12 konum) dizinin yazdýrýlacak ebatý
	segment .text
    global  _diziyi_yaz
_diziyi_yaz:
    enter 0, 0
    push esi
    push ebx

    xor esi, esi		; esi = 0
    mov ecx, [ebp+12]		; ecx = n
    mov ebx, [ebp+8]		; ebx = dizi adresi
yaz_döngüsü:
    push ecx
    push dword [ebx + 4*esi]	; push dizi [esi]
    push esi
    push dword ÇýktýBiçimi
    call _printf
    add esp, 12
    inc esi
    pop ecx
    loop yaz_döngüsü	; dec ecx

    pop ebx
    pop esi
    leave
    ret