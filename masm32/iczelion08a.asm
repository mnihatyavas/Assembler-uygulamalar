; iczelion08a.asm: Menü (Selam, Veda, Çýkýþ) ve Deneme zýplayan menü seçenekleri örneði.
;
; ml  /c  /coff iczelion08a.asm ==>iczelion08a.obj
; rc iczelion08a.rc ==>iczelion08a.res
; link /subsystem:windows iczelion08a.obj iczelion08a.res ==>iczelion08a.exe
; iczelion08a
;----------------------------------------------------------------------------------------------------------------------------------------
; ====8a.MENÜ====
; Menü tanýmý ayrý bir .rc=resource kaynak dosyada yapýlýp, res=obj ve birliktr link yapýlýr.
; Ana menüçubuk seçenekler POPUP, alt seçeneklerse MENUITEM anahtarkelimelerle tanýmlanýr.
; WindMain'de menü tanýtýmý (mov ps.lpszMenuName, OFFSET MenuAdi) ile yapýlýr.
; .rc'deki menü adý, .asm'deki MenuAdi dizgesiyle (türkçe karaktersiz) ayný olmalýdýr .
; WndProc metoddaki (.IF kMesaj == WM_COMMAND) menü seçeneklerini yönetir.
; .asm'deki .const enü adlarý ve ID numaralarýyla, .rc'deki #define ayný olmalýdýr.
; IF þartlarýnda (.IF ax == 3) yada (.IF ax == DENEME) kullanýmý aynýdýr.
; Menü seçeneklerinde &/ampersand hangi (küçük/büyük) harf önündeyse doðrudan o harfle iþletilebilir.
; MENU & harfleri Alt-harf, MENUITEM'dekiler doðrudan harf'le iþletilir. Oklarla ýþýldatýp yada fare týklamasý da geçerlidir.
; .rc'deki menü {} bloklama yerine BEGIN...END de kullanýlabilir.
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "Basit Pencere Sýnýfý", 0
    UygulamaAdi db "Pencerede menü yaratma", 0
    MenuAdi db "BenimMenum",0
    Test_dizgesi db "Þuanda 'Deneme' menü birimini seçtiniz.", 0
    Selam_dizgesi db "Merhaba arkadaþým, nasýlsýn?", 0
    Veda_dizgesi db "Hoþçakal, görüþmek üzere!..", 0
    AdSoyad_dizgesi db "Ben M.Nihat Yavaþ, Toroslar/Mersin'de ikamet ediyorum.", 0
    Telefon_dizgesi db "+90-551-555-94-64", 0
    Eposta_dizgesi db "mnihatyavas@gmail.com", 0

	.data?
    tiplemeYonetimi HINSTANCE ?
    komutSatiri LPSTR ?

	.const
    SELAM equ 11
    VEDA equ 12
    SON equ 19
    DENEME equ 2
    ADSOYAD equ 31
    TELEFON equ 32
    EPOSTA equ 33

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
    mov ps.lpfnWndProc, OFFSET WndProc	; Biralttaki baþvuru metodu adresi
    mov ps.cbClsExtra, NULL
    mov ps.cbWndExtra, NULL
    push tipYnt
    pop ps.hInstance
    mov ps.hbrBackground, COLOR_WINDOW+9	; Pencere zeminrengi açýkmavi
    mov ps.lpszMenuName, OFFSET MenuAdi
    mov ps.lpszClassName, OFFSET SinifAdi
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov ps.hIcon, eax
    mov ps.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov ps.hCursor, eax
    invoke RegisterClassEx, addr ps
    INVOKE CreateWindowEx, NULL, ADDR SinifAdi, ADDR UygulamaAdi, WS_OVERLAPPEDWINDOW,\
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, tipYnt, NULL
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
            invoke MessageBox, NULL,ADDR Selam_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ELSEIF ax == VEDA	; =12
            invoke MessageBox, NULL,ADDR Veda_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ELSEIF ax == 19	; =SON
            invoke DestroyWindow, penYnt
        .ELSEIF ax == 2	; =DENEME
            invoke MessageBox, NULL, ADDR Test_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ELSEIF ax == ADSOYAD	; =31
            invoke MessageBox, NULL,ADDR AdSoyad_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ELSEIF ax == TELEFON		; =32
            invoke MessageBox, NULL,ADDR Telefon_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ELSEIF ax == EPOSTA		; =33
            invoke MessageBox, NULL,ADDR Eposta_dizgesi, OFFSET UygulamaAdi, MB_OK
        .ENDIF
    .ELSE
        invoke DefWindowProc, penYnt, kMesaj, pPrm, sPrm
        ret
    .ENDIF
    xor eax, eax
    ret
WndProc endp

end ana