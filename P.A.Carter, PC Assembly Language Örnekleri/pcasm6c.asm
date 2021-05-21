; pcasm6c.asm: Belirtilen adet baþtan asal sayýlarý listeleme ASM örneði.
;
; nasm -fwin32 pcasm6c.asm
; gcc -m32 pcasm6c.obj pcasm6c.c
;--------------------------------------------------------------------------------------------------------------------------

	segment .text
    global  _asallar_listesi

; asallar_listesi fonksiyonu
; belirtilen adet asallarý baþtan (yada son 20 öncesinden) sýralar
; Parametreler:
;   dizi  - asal sayýlarý tutan dizi
;   n_adet - bulunacak asallar adedi
; C ilkörneði
; extern void asallar_listesi (int * dizi, unsigned n_adet)

    %define dizi ebp + 8
    %define n_adet ebp + 12
    %define n ebp - 4		; bulunan aktüel asal adedi
    %define karekök_taban ebp - 8	; tahminin karekökünün tabaný
    %define ilk_kontrol_kelimesi ebp - 10	; ilk kontrol kelimesi
    %define yeni_kontrol_kelimesi ebp - 12	; yeni kontrol kelimesi

_asallar_listesi:
    enter 12, 0	; yerel deðiþkenler için yer açýlýr
    push ebx	; muhtemel kayýtçýlarý sakla
    push esi

    fstcw word [ilk_kontrol_kelimesi]	; ilk kontrol kelimesi alýnýr
    mov ax, [ilk_kontrol_kelimesi]
    or ax, 0C00h		; bitleri 11 adede yuvarla
    mov [yeni_kontrol_kelimesi], ax
    fldcw word [yeni_kontrol_kelimesi]

    mov esi, [dizi]		; esi diziyi iþaretler
    mov dword [esi], 2		; ilk asal sayý: dizi [0] = 2
    mov dword [esi + 4], 3	; ikinci asal sayý: dizi [1] = 3
    mov ebx, 5		; ebx = tahmin = 5: bir üst tekli sayý
    mov dword [n], 2		; n = 2: bulunan aktüel asal adedi=2

; Önceki gibi sonraki asalý tüm altlara bölerek kontrol etmez,
; sadece önceki bulunan asallarbölerek kontrol saðlar,
; sonuçta bulduðu asalý dizi sonuna ekler.

while_sýnýr:
    mov eax, [n]
    cmp eax, [n_adet]		; while (n < n_adet)
    jnb short sýnýrdan_çýk

    mov ecx, 1		; ecx dizi endeks sayacý olacak
    push ebx		; tahmini yýðýna koy
    fild dword [esp]		; tahmini eþiþlemci yýðýnýna koy (tamsayý)
    pop ebx		; tahmini yýðýndan al
    fsqrt			; karekök (tahmin) hesapla
    fistp dword [karekök_taban]	; karekök_taban = taban (karekök (tahmin)) (taban=tamsayý hanesi)

; Bu iç döngüde taba karekök tahmin, tüm önceki bulunan asallar bölünür,
; bölünebilen varsa sayý asal deðildir; son asal atban(karekök(tahmin))'den büyükse, asaldýr.

while_faktör:
    mov eax, dword [esi + 4*ecx]		; eax = dizi [ecx]
    cmp eax, [karekök_taban]		; while (karekök_taban < dizi [ecx]
    jnbe short faktör_asal_çýk
    mov eax, ebx
    xor edx, edx	; edx=0
    div dword [esi + 4*ecx]
    or edx, edx	; && tahmin % dizi [ecx] != 0) (bölünmez)
    jz short faktör_asal_deðil_çýk
    inc ecx		; bulunan birsonraki asala bölmeyi dene
    jmp short while_faktör

; yeni bir asal bulundu!
faktör_asal_çýk:
    mov eax, [n]
    mov dword [esi + 4*eax], ebx		; tahmin asaldýr, dizi sonuna ekle
    inc eax
    mov [n], eax		; inc n

faktör_asal_deðil_çýk:
    add ebx, 2		; bir üst tekli sayýnýnasallýðý test edilecek
    jmp short while_sýnýr

sýnýrdan_çýk:
    fldcw word [ilk_kontrol_kelimesi]	; ilk kontrol kelimesini oku
    pop esi		; kayýtçýlarý al
    pop ebx

    leave
    ret