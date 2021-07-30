; iczelion08a.asm: Men� (Selam, Veda, ��k��) ve Deneme z�playan men� se�enekleri �rne�i.
;
; ml  /c  /coff iczelion08a.asm ==>iczelion08a.obj
; rc iczelion08a.rc ==>iczelion08a.res
; link /subsystem:windows iczelion08a.obj iczelion08a.res ==>iczelion08a.exe
; iczelion08a
;----------------------------------------------------------------------------------------------------------------------------------------
; ====8a.MEN�====
; Men� tan�m� ayr� bir .rc=resource kaynak dosyada yap�l�p, res=obj ve birliktr link yap�l�r.
; Ana men��ubuk se�enekler POPUP, alt se�eneklerse MENUITEM anahtarkelimelerle tan�mlan�r.
; WindMain'de men� tan�t�m� (mov ps.lpszMenuName, OFFSET MenuAdi) ile yap�l�r.
; .rc'deki men� ad�, .asm'deki MenuAdi dizgesiyle (t�rk�e karaktersiz) ayn� olmal�d�r .
; WndProc metoddaki (.IF kMesaj == WM_COMMAND) men� se�eneklerini y�netir.
; .asm'deki .const en� adlar� ve ID numaralar�yla, .rc'deki #define ayn� olmal�d�r.
; IF �artlar�nda (.IF ax == 3) yada (.IF ax == DENEME) kullan�m� ayn�d�r.
; Men� se�eneklerinde &/ampersand hangi (k���k/b�y�k) harf �n�ndeyse do�rudan o harfle i�letilebilir.
; MENU & harfleri Alt-harf, MENUITEM'dekiler do�rudan harf'le i�letilir. Oklarla ���ldat�p yada fare t�klamas� da ge�erlidir.
; .rc'deki men� {} bloklama yerine BEGIN...END de kullan�labilir.
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "Basit Pencere S�n�f�", 0
    UygulamaAdi db "Pencerede men� yaratma", 0
    MenuAdi db "BenimMenum",0
    Test_dizgesi db "�uanda 'Deneme' men� birimini se�tiniz.", 0
    Selam_dizgesi db "Merhaba arkada��m, nas�ls�n?", 0
    Veda_dizgesi db "Ho��akal, g�r��mek �zere!..", 0
    AdSoyad_dizgesi db "Ben M.Nihat Yava�, Toroslar/Mersin'de ikamet ediyorum.", 0
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
    mov ps.lpfnWndProc, OFFSET WndProc	; Biralttaki ba�vuru metodu adresi
    mov ps.cbClsExtra, NULL
    mov ps.cbWndExtra, NULL
    push tipYnt
    pop ps.hInstance
    mov ps.hbrBackground, COLOR_WINDOW+9	; Pencere zeminrengi a��kmavi
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