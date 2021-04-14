; nasm011.asm: Bo� bir windows penceresi yaratma �rne�i.
;---------------------------------------------------------------------------------------------
				; Temel Pencere, 32 bit
    RENKL�_PENCERE EQU 5		; Sabitler
    CS_BYTEH�ZALIPENCERE EQU 2000h
    CS_YATAY��Z�M EQU 2
    CS_D�KEY��Z�M EQU 1
    CW_VARSAYILIYIKULLAN EQU 80000000h
    IDC_OK EQU 7F00h
    IDI_UYGULAMA EQU 7F00h
    RES�M_�MLEC� EQU 2
    RES�M_�KONU EQU 1
    LR_PAYLA�ILDI EQU 8000h
    SIFIR EQU 0
    SW_NORMALG�STER EQU 1
    WM_�MHA EQU 2
    WS_EX_B�LE��K EQU 2000000h
    WS_�RT��ENPENCERE EQU 0CF0000h

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

global _main			; Programlamaya giri� noktas�

	section .data		; Veri b�l�m� ilk de�erleri
    PencereninAd� db "Temel Pencere 32", 0
    S�n�fAd� db "Window", 0

	section .bss		; �lkde�ersiz veri b�l�m�
    hTipleme resd 1

	section .text		; Kodlama B�l�m�
_main:
    push SIFIR
    call _GetModuleHandleA@4
    mov dword [hTipleme], EAX

    call  EsasPencere

.��k��:
    push SIFIR
    call _ExitProcess@4

EsasPencere:
    push EBP			; Bir y���n �er�evesi kural�m
    mov EBP, ESP
    sub ESP, 80			; Yerel de�i�kenler i�in 80 byte

    %define wc EBP - 80		; WNDCLASSEX pencere s�n�f yap�lar�na 48 bytes
    %define wc.cbSize EBP - 80
    %define wc.style EBP - 76
    %define wc.lpfnPencere��lemi EBP - 72
    %define wc.cbClsExtra EBP - 68
    %define wc.cbWndExtra EBP - 64
    %define wc.hTipleme EBP - 60
    %define wc.hIcon EBP - 56
    %define wc.hCursor EBP - 52
    %define wc.hbrBackground EBP - 48
    %define wc.lpszMenuName EBP - 44
    %define wc.lpszS�n�fAd� EBP - 40
    %define wc.hIconSm EBP - 36

    %define msg EBP - 32		; MSG mesaj yap�s�na 28 byte
    %define msg.hwnd EBP - 32	; Herbir eleman�n ayr��t�r�lmas� gerekmez
    %define msg.message EBP - 28	; ama bu programda, herbir eleman�n y���ndaki
    %define msg.wParam EBP - 24	; yeri teker teker tan�mlanm��t�r
    %define msg.lParam EBP - 20
    %define msg.time EBP - 16
    %define msg.pt.x EBP - 12
    %define msg.pt.y EBP - 8

    %define hWnd EBP - 4

    mov dword [wc.cbSize], 48		; [EBP - 80]
    mov dword [wc.style], CS_YATAY��Z�M | CS_D�KEY��Z�M | CS_BYTEH�ZALIPENCERE  ; [EBP - 76]
    mov dword [wc.lpfnPencere��lemi], Pencere��lemi ; [EBP - 72]
    mov dword [wc.cbClsExtra], SIFIR	; [EBP - 68]
    mov dword [wc.cbWndExtra], SIFIR	; [EBP - 64]
    mov EAX, dword [hTipleme]		; Global
    mov dword [wc.hTipleme], EAX	; [EBP - 60]

    push LR_PAYLA�ILDI
    push SIFIR
    push SIFIR
    push RES�M_�KONU
    push IDI_UYGULAMA
    push SIFIR
    call _LoadImageA@24		; B�y�k program ikonu
    mov dword [wc.hIcon], EAX		; [EBP - 56]

    push LR_PAYLA�ILDI
    push SIFIR
    push SIFIR
    push RES�M_�MLEC�
    push IDC_OK
    push SIFIR
    call _LoadImageA@24		; �mle�
    mov dword [wc.hCursor], EAX	; [EBP - 52]

    mov dword [wc.hbrBackground], RENKL�_PENCERE + 1	; [EBP - 48]
    mov dword [wc.lpszMenuName], SIFIR ; [EBP - 44]
    mov dword [wc.lpszS�n�fAd�], S�n�fAd�	; [EBP - 40]

    push LR_PAYLA�ILDI
    push SIFIR
    push SIFIR
    push RES�M_�KONU
    push IDI_UYGULAMA
    push SIFIR
    call _LoadImageA@24		; K���k program ikonu
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
    push WS_�RT��ENPENCERE
    push PencereninAd�
    push S�n�fAd�
    push WS_EX_B�LE��K
    call _CreateWindowExA@48
    mov dword [hWnd], EAX		; [EBP - 4]

    push SW_NORMALG�STER
    push dword [hWnd]		; [EBP - 4]
    call _ShowWindow@8

    push dword [hWnd] 		; [EBP - 4]
    call _UpdateWindow@4

.MesajD�ng�s�:
    lea EAX, [msg]			; [EBP - 32]
    push SIFIR
    push SIFIR
    push SIFIR
    push EAX
    call _GetMessageA@16
    cmp EAX, 0
    je .Tamamland�

    lea EAX, [msg]			; [EBP - 32]
    push EAX
    push dword [hWnd]		; [EBP - 4]
    call _IsDialogMessageA@8		; Klayve bas��lar� i�in
    cmp EAX, 0
    jne .MesajD�ng�s�		; Alttaki TranslateMessage ve DispatchMessage'� esge�

    lea EAX, [msg]			; [EBP - 32]
    push EAX
    call _TranslateMessage@4

    lea EAX, [msg]			; [EBP - 32]
    push EAX

    call _DispatchMessageA@4
    jmp .MesajD�ng�s�

.Tamamland�:
    mov ESP, EBP			; Y���n �erevesi silinir
    pop EBP
    xor EAX, EAX
    ret

Pencere��lemi:
    push  EBP			; Bir y���n �er�evesi kurulur
    mov   EBP, ESP

   %define hWnd EBP + 8		; �a��ran programdan aktar�lan 4
   %define uMsg EBP + 12		; parametrenin konumu
   %define wParam EBP + 16		; Bu parametrelere art�k ismen eri�ilebilir
   %define lParam EBP + 20

    cmp dword [uMsg], WM_�MHA	; [EBP + 12]
    je WM�MHA

Varsay�l�Mesaj:
    push  dword [lParam]                           ; [EBP + 20]
    push  dword [wParam]                           ; [EBP + 16]
    push  dword [uMsg]                             ; [EBP + 12]
    push  dword [hWnd]                             ; [EBP + 8]
    call  _DefWindowProcA@16

    mov ESP, EBP			; Y���n �er�evesi silinie
    pop EBP
    ret 16				; 4 parametre y���ndan ��kar�l�r ve d�n�l�r/sonlan�r

WM�MHA:
    push SIFIR
    call _PostQuitMessage@4

    xor EAX, EAX			; WM_�MHA i�lendi, 0 d�nd�r
    mov ESP, EBP			; Y���n �er�evesini sil
    pop EBP
    ret 16				; 4 parametre y���ndan ��kar�l�r ve d�n�l�r/sonlan�r