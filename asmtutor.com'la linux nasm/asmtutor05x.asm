; asmtutor05x.asm: Di�er programlara dahiledilecek altrutinler �rne�i.

;------------------------------------------
; int adant=atoi (Ascii'den tamsay�ya �evrim fonksiyonu)
adant:
    push ebx	; Arg�man tamsay�ya �evrilirken EBX, ECX, EDX, ESI �nce y���na konur, fonksiyondan ��karken de al�n�r
    push ecx
    push edx
    push esi
    mov esi, eax	; Arg�man EAX'dan ESI kay�t��ya ta��n�r
    mov eax, 0	; Tamsay� arg�man �evrim sonucu kay�t��s�
    mov ecx, 0	; Arg�mandaki tamsay� rakam adedi sayac�
.rakama_cevrim:
    xor ebx, ebx	; EBX=0
    mov bl, [esi+ecx]	; Akt�el ascii karakter=BL
    cmp bl, 48
    jl .bitir		; BL < ascii48 ise bitir
    cmp bl, 57
    jg .bitir		; BL > ascii57 ise bitir
    sub bl, 48	; ascii'den tamsay�y� soyutla
    add eax, ebx	; EAX +=BL
    mov ebx, 10
    mul ebx		; EAX *=10
    inc ecx		; Arg�mandaki rakam adedi sayac�
    jmp .rakama_cevrim	; Arg�manda rakam kalmay�ncaya kadar d�ng�ye devam
.bitir:
    cmp ecx, 0
    je .sonlan	; Arg�man rakam adedi=0 ise ba�ka i�lem gerekmez
    mov ebx, 10
    div ebx		; EAX /=10 (son 10'lu kat�n iptali)
.sonlan:
    pop esi		; EBX, ECX, EDX, ESI ba�lang�� de�erlerine d�ner
    pop edx
    pop ecx
    pop ebx
    ret

;------------------------------------------
; void tyaz (Altsat�rs�z tamsay� yazd�rma fonksiyonu)
tyaz:
    push eax
    push ecx
    push edx
    push esi
    mov ecx, 0	; Saya�=0
tekrar_bol:
    inc ecx		; Sayac� birart�r
    mov edx, 0
    mov esi, 10	; b�len=ESI=10
    idiv esi		; EAX /=ESI (b�l�m=EAX, kalan=EDX)
    add edx, 48
    push edx	; Kalan� y���na sakla
    cmp eax, 0
    jnz tekrar_bol	; EAX=0 de�ilse b�l�m d�ng�s�ne devam
tekrar_yaz:
    dec ecx		; Sayac� birazalt
    mov eax, esp	; Kalan EDX y���n adresini EAX'a ta��
    call dyaz
    pop eax	; y���ndaki yaz�lan kalan� sil
    cmp ecx, 0
    jnz tekrar_yaz	; Saya�=0 de�ilse dyaz d�ng�s�ne devam
    pop esi
    pop edx
    pop ecx
    pop eax
    ret

;------------------------------------------
; void tyazAS (Altsat�rl� tamsay� yazd�rma fonksiyonu)
tyazAS:
    call tyaz
    push eax
    mov eax, 0Ah	; Altsat�ra atlanacak
    push eax
    mov eax, esp
    call dyaz
    pop eax
    pop eax
    ret

;------------------------------------------
; int uzunluk (Mesaj dizgesi uzunlu�unu hesaplay�p d�nd�r�r)
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
; void dyaz (Altsat�rs�z dizge yazd�rma fonksiyonu)
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
; void dyazAS (Altsat�rl� dizge yazd�rma fonksiyonu)
dyazAS:
    call dyaz		; Mesaj sonunda 0Ah yoksa sadece yazar, altsat�ra ge�mez
    push eax
    mov eax, 0Ah
    push eax
    mov eax, esp
    call dyaz		; S�f�r uzunlukta dizge yazar ve altsat�ra ge�er
    pop eax
    pop eax
    ret

;------------------------------------------
; void son (Programdan hatas�z nihai ��k��)
son:
    mov ebx, 0
    mov eax, 1
    int 80h
    ret