; nasm011.asm: Boþ bir windows penceresi yaratma örneði.
;---------------------------------------------------------------------------------------------
				; Temel Pencere, 32 bit
    RENKLÝ_PENCERE EQU 5		; Sabitler
    CS_BYTEHÝZALIPENCERE EQU 2000h
    CS_YATAYÇÝZÝM EQU 2
    CS_DÝKEYÇÝZÝM EQU 1
    CW_VARSAYILIYIKULLAN EQU 80000000h
    IDC_OK EQU 7F00h
    IDI_UYGULAMA EQU 7F00h
    RESÝM_ÝMLECÝ EQU 2
    RESÝM_ÝKONU EQU 1
    LR_PAYLAÞILDI EQU 8000h
    SIFIR EQU 0
    SW_NORMALGÖSTER EQU 1
    WM_ÝMHA EQU 2
    WS_EX_BÝLEÞÝK EQU 2000000h
    WS_ÖRTÜÞENPENCERE EQU 0CF0000h

    PencereEni EQU 1000
    PencereBoyu EQU 550

    extern _CreateWindowExA@48	; Harici rutinlerin ithali
    extern _DefWindowProcA@16
    extern _DispatchMessageA@4
    extern _ExitProcess@4
    extern _GetMessageA@16
    extern _GetModuleHandleA@4
    extern _IsDialogMessageA@8
    extern _LoadImageA@24
    extern _PostQuitMessage@4
    extern _RegisterClassExA@4
    extern _ShowWindow@8
    extern _TranslateMessage@4
    extern _UpdateWindow@4

global _main			; Programlamaya giriþ noktasý

	section .data		; Veri bölümü ilk deðerleri
    PencereninAdý db "Temel Pencere 32", 0
    SýnýfAdý db "Window", 0

	section .bss		; Ýlkdeðersiz veri bölümü
    hTipleme resd 1

	section .text		; Kodlama Bölümü
_main:
    push SIFIR
    call _GetModuleHandleA@4
    mov dword [hTipleme], EAX

    call  EsasPencere

.Çýkýþ:
    push SIFIR
    call _ExitProcess@4

EsasPencere:
    push EBP			; Bir yýðýn çerçevesi kuralým
    mov EBP, ESP
    sub ESP, 80			; Yerel deðiþkenler için 80 byte

    %define wc EBP - 80		; WNDCLASSEX pencere sýnýf yapýlarýna 48 bytes
    %define wc.cbSize EBP - 80
    %define wc.style EBP - 76
    %define wc.lpfnPencereÝþlemi EBP - 72
    %define wc.cbClsExtra EBP - 68
    %define wc.cbWndExtra EBP - 64
    %define wc.hTipleme EBP - 60
    %define wc.hIcon EBP - 56
    %define wc.hCursor EBP - 52
    %define wc.hbrBackground EBP - 48
    %define wc.lpszMenuName EBP - 44
    %define wc.lpszSýnýfAdý EBP - 40
    %define wc.hIconSm EBP - 36

    %define msg EBP - 32		; MSG mesaj yapýsýna 28 byte
    %define msg.hwnd EBP - 32	; Herbir elemanýn ayrýþtýrýlmasý gerekmez
    %define msg.message EBP - 28	; ama bu programda, herbir elemanýn yýðýndaki
    %define msg.wParam EBP - 24	; yeri teker teker tanýmlanmýþtýr
    %define msg.lParam EBP - 20
    %define msg.time EBP - 16
    %define msg.pt.x EBP - 12
    %define msg.pt.y EBP - 8

    %define hWnd EBP - 4

    mov dword [wc.cbSize], 48		; [EBP - 80]
    mov dword [wc.style], CS_YATAYÇÝZÝM | CS_DÝKEYÇÝZÝM | CS_BYTEHÝZALIPENCERE  ; [EBP - 76]
    mov dword [wc.lpfnPencereÝþlemi], PencereÝþlemi ; [EBP - 72]
    mov dword [wc.cbClsExtra], SIFIR	; [EBP - 68]
    mov dword [wc.cbWndExtra], SIFIR	; [EBP - 64]
    mov EAX, dword [hTipleme]		; Global
    mov dword [wc.hTipleme], EAX	; [EBP - 60]

    push LR_PAYLAÞILDI
    push SIFIR
    push SIFIR
    push RESÝM_ÝKONU
    push IDI_UYGULAMA
    push SIFIR
    call _LoadImageA@24		; Büyük program ikonu
    mov dword [wc.hIcon], EAX		; [EBP - 56]

    push LR_PAYLAÞILDI
    push SIFIR
    push SIFIR
    push RESÝM_ÝMLECÝ
    push IDC_OK
    push SIFIR
    call _LoadImageA@24		; Ýmleç
    mov dword [wc.hCursor], EAX	; [EBP - 52]

    mov dword [wc.hbrBackground], RENKLÝ_PENCERE + 1	; [EBP - 48]
    mov dword [wc.lpszMenuName], SIFIR ; [EBP - 44]
    mov dword [wc.lpszSýnýfAdý], SýnýfAdý	; [EBP - 40]

    push LR_PAYLAÞILDI
    push SIFIR
    push SIFIR
    push RESÝM_ÝKONU
    push IDI_UYGULAMA
    push SIFIR
    call _LoadImageA@24		; Küçük program ikonu
    mov dword [wc.hIconSm], EAX	; [EBP - 36]

    lea EAX, [wc]			; [EBP - 80]
    push  EAX
    call _RegisterClassExA@4

    push SIFIR
    push dword [hTipleme]
    push SIFIR
    push SIFIR
    push PencereBoyu
    push PencereEni
    push CW_VARSAYILIYIKULLAN
    push CW_VARSAYILIYIKULLAN
    push WS_ÖRTÜÞENPENCERE
    push PencereninAdý
    push SýnýfAdý
    push WS_EX_BÝLEÞÝK
    call _CreateWindowExA@48
    mov dword [hWnd], EAX		; [EBP - 4]

    push SW_NORMALGÖSTER
    push dword [hWnd]		; [EBP - 4]
    call _ShowWindow@8

    push dword [hWnd] 		; [EBP - 4]
    call _UpdateWindow@4

.MesajDöngüsü:
    lea EAX, [msg]			; [EBP - 32]
    push SIFIR
    push SIFIR
    push SIFIR
    push EAX
    call _GetMessageA@16
    cmp EAX, 0
    je .Tamamlandý

    lea EAX, [msg]			; [EBP - 32]
    push EAX
    push dword [hWnd]		; [EBP - 4]
    call _IsDialogMessageA@8		; Klayve basýþlarý için
    cmp EAX, 0
    jne .MesajDöngüsü		; Alttaki TranslateMessage ve DispatchMessage'ý esgeç

    lea EAX, [msg]			; [EBP - 32]
    push EAX
    call _TranslateMessage@4

    lea EAX, [msg]			; [EBP - 32]
    push EAX

    call _DispatchMessageA@4
    jmp .MesajDöngüsü

.Tamamlandý:
    mov ESP, EBP			; Yýðýn çerevesi silinir
    pop EBP
    xor EAX, EAX
    ret

PencereÝþlemi:
    push  EBP			; Bir yýðýn çerçevesi kurulur
    mov   EBP, ESP

   %define hWnd EBP + 8		; Çaðýran programdan aktarýlan 4
   %define uMsg EBP + 12		; parametrenin konumu
   %define wParam EBP + 16		; Bu parametrelere artýk ismen eriþilebilir
   %define lParam EBP + 20

    cmp dword [uMsg], WM_ÝMHA	; [EBP + 12]
    je WMÝMHA

VarsayýlýMesaj:
    push  dword [lParam]                           ; [EBP + 20]
    push  dword [wParam]                           ; [EBP + 16]
    push  dword [uMsg]                             ; [EBP + 12]
    push  dword [hWnd]                             ; [EBP + 8]
    call  _DefWindowProcA@16

    mov ESP, EBP			; Yýðýn çerçevesi silinie
    pop EBP
    ret 16				; 4 parametre yýðýndan çýkarýlýr ve dönülür/sonlanýr

WMÝMHA:
    push SIFIR
    call _PostQuitMessage@4

    xor EAX, EAX			; WM_ÝMHA iþlendi, 0 döndür
    mov ESP, EBP			; Yýðýn çerçevesini sil
    pop EBP
    ret 16				; 4 parametre yýðýndan çýkarýlýr ve dönülür/sonlanýr