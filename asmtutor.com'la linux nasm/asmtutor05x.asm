; asmtutor05x.asm: Diðer programlara dahiledilecek altrutinler örneði.

;------------------------------------------
; int adant=atoi (Ascii'den tamsayýya çevrim fonksiyonu)
adant:
    push ebx	; Argüman tamsayýya çevrilirken EBX, ECX, EDX, ESI önce yýðýna konur, fonksiyondan çýkarken de alýnýr
    push ecx
    push edx
    push esi
    mov esi, eax	; Argüman EAX'dan ESI kayýtçýya taþýnýr
    mov eax, 0	; Tamsayý argüman çevrim sonucu kayýtçýsý
    mov ecx, 0	; Argümandaki tamsayý rakam adedi sayacý
.rakama_cevrim:
    xor ebx, ebx	; EBX=0
    mov bl, [esi+ecx]	; Aktüel ascii karakter=BL
    cmp bl, 48
    jl .bitir		; BL < ascii48 ise bitir
    cmp bl, 57
    jg .bitir		; BL > ascii57 ise bitir
    sub bl, 48	; ascii'den tamsayýyý soyutla
    add eax, ebx	; EAX +=BL
    mov ebx, 10
    mul ebx		; EAX *=10
    inc ecx		; Argümandaki rakam adedi sayacý
    jmp .rakama_cevrim	; Argümanda rakam kalmayýncaya kadar döngüye devam
.bitir:
    cmp ecx, 0
    je .sonlan	; Argüman rakam adedi=0 ise baþka iþlem gerekmez
    mov ebx, 10
    div ebx		; EAX /=10 (son 10'lu katýn iptali)
.sonlan:
    pop esi		; EBX, ECX, EDX, ESI baþlangýç deðerlerine döner
    pop edx
    pop ecx
    pop ebx
    ret

;------------------------------------------
; void tyaz (Altsatýrsýz tamsayý yazdýrma fonksiyonu)
tyaz:
    push eax
    push ecx
    push edx
    push esi
    mov ecx, 0	; Sayaç=0
tekrar_bol:
    inc ecx		; Sayacý birartýr
    mov edx, 0
    mov esi, 10	; bölen=ESI=10
    idiv esi		; EAX /=ESI (bölüm=EAX, kalan=EDX)
    add edx, 48
    push edx	; Kalaný yýðýna sakla
    cmp eax, 0
    jnz tekrar_bol	; EAX=0 deðilse bölüm döngüsüne devam
tekrar_yaz:
    dec ecx		; Sayacý birazalt
    mov eax, esp	; Kalan EDX yýðýn adresini EAX'a taþý
    call dyaz
    pop eax	; yýðýndaki yazýlan kalaný sil
    cmp ecx, 0
    jnz tekrar_yaz	; Sayaç=0 deðilse dyaz döngüsüne devam
    pop esi
    pop edx
    pop ecx
    pop eax
    ret

;------------------------------------------
; void tyazAS (Altsatýrlý tamsayý yazdýrma fonksiyonu)
tyazAS:
    call tyaz
    push eax
    mov eax, 0Ah	; Altsatýra atlanacak
    push eax
    mov eax, esp
    call dyaz
    pop eax
    pop eax
    ret

;------------------------------------------
; int uzunluk (Mesaj dizgesi uzunluðunu hesaplayýp döndürür)
uzunluk:
    push ebx
    mov ebx, eax
birsonraki_karakter:
    cmp byte [eax], 0
    jz bitti
    inc eax
    jmp birsonraki_karakter
bitti:
    sub eax, ebx
    pop ebx
    ret

;------------------------------------------
; void dyaz (Altsatýrsýz dizge yazdýrma fonksiyonu)
dyaz:
    push edx
    push ecx
    push ebx
    push eax
    call uzunluk
    mov edx, eax
    pop eax
    mov ecx, eax
    mov ebx, 1
    mov eax, 4
    int 80h
    pop ebx
    pop ecx
    pop edx
    ret

;------------------------------------------
; void dyazAS (Altsatýrlý dizge yazdýrma fonksiyonu)
dyazAS:
    call dyaz		; Mesaj sonunda 0Ah yoksa sadece yazar, altsatýra geçmez
    push eax
    mov eax, 0Ah
    push eax
    mov eax, esp
    call dyaz		; Sýfýr uzunlukta dizge yazar ve altsatýra geçer
    pop eax
    pop eax
    ret

;------------------------------------------
; void son (Programdan hatasýz nihai çýkýþ)
son:
    mov ebx, 0
    mov eax, 1
    int 80h
    ret