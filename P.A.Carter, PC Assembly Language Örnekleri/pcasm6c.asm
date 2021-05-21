; pcasm6c.asm: Belirtilen adet ba�tan asal say�lar� listeleme ASM �rne�i.
;
; nasm -fwin32 pcasm6c.asm
; gcc -m32 pcasm6c.obj pcasm6c.c
;--------------------------------------------------------------------------------------------------------------------------

	segment .text
    global  _asallar_listesi

; asallar_listesi fonksiyonu
; belirtilen adet asallar� ba�tan (yada son 20 �ncesinden) s�ralar
; Parametreler:
;   dizi  - asal say�lar� tutan dizi
;   n_adet - bulunacak asallar adedi
; C ilk�rne�i
; extern void asallar_listesi (int * dizi, unsigned n_adet)

    %define dizi ebp + 8
    %define n_adet ebp + 12
    %define n ebp - 4		; bulunan akt�el asal adedi
    %define karek�k_taban ebp - 8	; tahminin karek�k�n�n taban�
    %define ilk_kontrol_kelimesi ebp - 10	; ilk kontrol kelimesi
    %define yeni_kontrol_kelimesi ebp - 12	; yeni kontrol kelimesi

_asallar_listesi:
    enter 12, 0	; yerel de�i�kenler i�in yer a��l�r
    push ebx	; muhtemel kay�t��lar� sakla
    push esi

    fstcw word [ilk_kontrol_kelimesi]	; ilk kontrol kelimesi al�n�r
    mov ax, [ilk_kontrol_kelimesi]
    or ax, 0C00h		; bitleri 11 adede yuvarla
    mov [yeni_kontrol_kelimesi], ax
    fldcw word [yeni_kontrol_kelimesi]

    mov esi, [dizi]		; esi diziyi i�aretler
    mov dword [esi], 2		; ilk asal say�: dizi [0] = 2
    mov dword [esi + 4], 3	; ikinci asal say�: dizi [1] = 3
    mov ebx, 5		; ebx = tahmin = 5: bir �st tekli say�
    mov dword [n], 2		; n = 2: bulunan akt�el asal adedi=2

; �nceki gibi sonraki asal� t�m altlara b�lerek kontrol etmez,
; sadece �nceki bulunan asallarb�lerek kontrol sa�lar,
; sonu�ta buldu�u asal� dizi sonuna ekler.

while_s�n�r:
    mov eax, [n]
    cmp eax, [n_adet]		; while (n < n_adet)
    jnb short s�n�rdan_��k

    mov ecx, 1		; ecx dizi endeks sayac� olacak
    push ebx		; tahmini y���na koy
    fild dword [esp]		; tahmini e�i�lemci y���n�na koy (tamsay�)
    pop ebx		; tahmini y���ndan al
    fsqrt			; karek�k (tahmin) hesapla
    fistp dword [karek�k_taban]	; karek�k_taban = taban (karek�k (tahmin)) (taban=tamsay� hanesi)

; Bu i� d�ng�de taba karek�k tahmin, t�m �nceki bulunan asallar b�l�n�r,
; b�l�nebilen varsa say� asal de�ildir; son asal atban(karek�k(tahmin))'den b�y�kse, asald�r.

while_fakt�r:
    mov eax, dword [esi + 4*ecx]		; eax = dizi [ecx]
    cmp eax, [karek�k_taban]		; while (karek�k_taban < dizi [ecx]
    jnbe short fakt�r_asal_��k
    mov eax, ebx
    xor edx, edx	; edx=0
    div dword [esi + 4*ecx]
    or edx, edx	; && tahmin % dizi [ecx] != 0) (b�l�nmez)
    jz short fakt�r_asal_de�il_��k
    inc ecx		; bulunan birsonraki asala b�lmeyi dene
    jmp short while_fakt�r

; yeni bir asal bulundu!
fakt�r_asal_��k:
    mov eax, [n]
    mov dword [esi + 4*eax], ebx		; tahmin asald�r, dizi sonuna ekle
    inc eax
    mov [n], eax		; inc n

fakt�r_asal_de�il_��k:
    add ebx, 2		; bir �st tekli say�n�nasall��� test edilecek
    jmp short while_s�n�r

s�n�rdan_��k:
    fldcw word [ilk_kontrol_kelimesi]	; ilk kontrol kelimesini oku
    pop esi		; kay�t��lar� al
    pop ebx

    leave
    ret