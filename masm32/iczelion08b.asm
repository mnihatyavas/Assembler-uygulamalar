; iczelion08b.asm: Men� (Selam, Veda, ��k��) ve Tan�t z�playan men� se�enekleri �rne�i.
;
; ml  /c  /coff iczelion08b.asm
; rc iczelion08b.rc
; link /subsystem:windows iczelion08b.obj iczelion08b.res
; iczelion08b
;----------------------------------------------------------------------------------------------------------------------------------------
; ====8b.MEN�====
; (mov ps.lpszMenuName, OFFSET MenuAdi) kullan�lmamakta, onun yerine .data?'da (men�Yonetimi HMENU ?)
; tan�mlan�p WinMain i�inde ("invoke LoadMenu, tipYnt, OFFSET MenuAdi" ve "mov    MenuYonetimi, eax")
; akabinde INVOKE CreateWindowEx sonu (menuYonetimi, tipYnt, NULL) olmaktad�r.
; �lk y�ntemde penceres�n�f�n�n varsay�l� men�s� olup, her pencerede ayn� men� belirir; ikinci y�ntemdeyse
; ayn� s�n�f�n farkl� pencerelerinde farkl� men�ler yans�t�labilmektedir.
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "Basit Pencere S�n�f�", 0
    UygulamaAdi db "Pencerede men� yaratma", 0
    MenuAdi db "BenimMenum",0
    Selam_dizgesi db "Merhaba arkada��m, nas�ls�n?", 0
    Veda_dizgesi db "Ho��akal, g�r��mek �zere!..", 0
    AdSoyad_dizgesi db "Ben M.Nihat Yava�, Toroslar/Mersin'de ikamet ediyorum.", 0
    Telefon_dizgesi db "+90-551-555-94-64", 0
    Eposta_dizgesi db "mnihatyavas@gmail.com", 0
    Yardim_dizgesi db "Yard�m i�in 'Iczelion.chm' html ders, �rnekler ve cevaplar d�k�man�na g�zat�n.", 0

	.data?
    tiplemeYonetimi HINSTANCE ?
    komutSatiri LPSTR ?
    menuYonetimi HMENU ?

	.const
    SELAM equ 11
    VEDA equ 12
    SON equ 19
    ADSOYAD equ 21
    TELEFON equ 22
    EPOSTA equ 23
    YARDIM equ 3

	.code
ana:
    invoke GetModuleHandle, NULL
    mov tiplemeYonetimi, eax
    invoke GetCommandLine
    mov komutSatiri, eax
    invoke WinMain, tiplemeYonetimi, NULL, komutSatiri, SW_SHOWDEFAULT
    invoke ExitProcess, eax

WinMain proc tipYnt:HINSTANCE, tipYnt0:HINSTANCE, kmtStr:LPSTR, kmtGstr:DWORD
    LOCAL ps: WNDCLASSEX
    LOCAL mesaj: MSG
    LOCAL pYnt: HWND
    mov ps.cbSize, SIZEOF ps
    mov ps.style, CS_HREDRAW or CS_VREDRAW
    mov ps.lpfnWndProc, OFFSET WndProc	; Biralttaki ba�vuru metodu adresi
    mov ps.cbClsExtra, NULL
    mov ps.cbWndExtra, NULL
    push tipYnt
    pop ps.hInstance
    mov ps.hbrBackground, COLOR_WINDOW+9	; Pencere zeminrengi a��kmavi
    mov ps.lpszClassName, OFFSET SinifAdi
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov ps.hIcon, eax
    mov ps.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov ps.hCursor, eax
    invoke RegisterClassEx, addr ps
    invoke LoadMenu, tipYnt, OFFSET MenuAdi
    mov menuYonetimi, eax
    INVOKE CreateWindowEx, NULL, ADDR SinifAdi, ADDR UygulamaAdi, WS_OVERLAPPEDWINDOW,\
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, menuYonetimi, tipYnt, NULL
    mov pYnt, eax
    INVOKE ShowWindow, pYnt, SW_SHOWNORMAL
    INVOKE UpdateWindow, pYnt
    .WHILE TRUE
        INVOKE GetMessage, ADDR mesaj, NULL, 0, 0
        .BREAK .IF (! eax)
        INVOKE TranslateMessage, ADDR mesaj
        INVOKE DispatchMessage, ADDR mesaj
    .ENDW
    mov eax, mesaj.wParam
    ret
WinMain endp

WndProc proc penYnt:HWND, kMesaj:UINT, pPrm:WPARAM, sPrm:LPARAM
    .IF kMesaj == WM_DESTROY
        invoke PostQuitMessage, NULL
    .ELSEIF kMesaj == WM_COMMAND
        mov eax, pPrm
        .IF ax == SELAM	; =11
            invoke MessageBox, NULL, ADDR Selam_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ELSEIF ax == VEDA	; =12
            invoke MessageBox, NULL, ADDR Veda_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ELSEIF ax == 19	; =SON
            invoke DestroyWindow, penYnt
        .ELSEIF ax == ADSOYAD	; =21
            invoke MessageBox, NULL, ADDR AdSoyad_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ELSEIF ax == TELEFON		; =22
            invoke MessageBox, NULL, ADDR Telefon_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ELSEIF ax == 23		; =EPOSTA
            invoke MessageBox, NULL, ADDR Eposta_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ELSEIF ax == 3		; =EPOSTA
            invoke MessageBox, NULL, ADDR Yardim_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ENDIF
    .ELSE
        invoke DefWindowProc, penYnt, kMesaj, pPrm, sPrm
        ret
    .ENDIF
    xor eax, eax
    ret
WndProc endp

end ana