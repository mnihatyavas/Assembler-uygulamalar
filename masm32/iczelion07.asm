; iczelion07.asm: Farenin týklandýðý pencere konumuna mesaj yazdýrma örneði.
;
; ml  /c  /coff iczelion07.asm
; link /subsystem:windows iczelion07.obj
; iczelion07
;----------------------------------------------------------------------------------------------------------------------------------------
; ====7.FAREYLE VERÝGÝRÝÞÝ====
; Önce "times new roman", 20px ebatlý, 10 derece eðimli yazýfonuailesi seçiliyor, sonra fare týklama
; konumu tespit edilerek, mesaj yazýlýyor.
; Fare duyarlýðý:  WM_LBUTTONDOWN, WM_RBUTTONDOWN ve WM_LBUTTONUP, WM_RBUTTONUP 
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "BasitPencereSýnýfý", 0
    UygulamaAdi db " Fare tiklama konumuna mesaj yazma ", 0
    YazifonuAdi db "times new roman", 0
    FareTiklamasi db 0	; 0=FALSE, 1=TRUE

	.data?
    tiplemeYonetimi HINSTANCE ?
    komutSatiri LPSTR ?
    tiklananKonum POINT <>	; (tK.x, tK.y)

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
    mov ps.lpszMenuName, NULL
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
    LOCAL aiYnt: HDC
    LOCAL by: PAINTSTRUCT
    LOCAL fonYnt: HFONT
    .IF kMesaj == WM_DESTROY
        invoke PostQuitMessage, NULL
    .ELSEIF kMesaj == WM_LBUTTONDOWN	; Fare soluna basýldýysa
        ; sPrm'ýn alt 2 byte/word (16-bit) x-konum, üst 2 btye/word ise y-konum içerir
        mov eax, sPrm
        and eax, 0ffffh
        mov tiklananKonum.x, eax
        mov eax, sPrm
        shr eax, 16
        mov tiklananKonum.y, eax
        mov FareTiklamasi, TRUE
        invoke InvalidateRect, penYnt, NULL, TRUE
    .ELSEIF kMesaj == WM_PAINT	; Týklanan konuma mesaj yazma
        invoke BeginPaint, penYnt, ADDR by
        mov aiYnt, eax
        ; Karakter ebat:20x20px, koyuluk:800, arial
        invoke CreateFont, 20, 0, 100, 0, 800, 0, 0, 0, OEM_CHARSET, OUT_DEFAULT_PRECIS,\
           CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_SCRIPT, ADDR YazifonuAdi
        invoke SelectObject, aiYnt, eax
        mov fonYnt, eax
        RGB 255, 255, 0	; Sarý metin
        invoke SetTextColor, aiYnt, eax
        RGB 255, 0, 0        ; Kýrmýzý zemin
        invoke SetBkColor, aiYnt, eax
        .IF FareTiklamasi
            ;;invoke lstrlen, ADDR UygulamaAdi	; INVOKE yerine SIZEOF
            invoke TextOut, aiYnt, tiklananKonum.x, tiklananKonum.y, ADDR UygulamaAdi, SIZEOF UygulamaAdi -1	; eax=SIZEOF UygulamaAdi
        .ENDIF
        invoke EndPaint, penYnt, ADDR by
    .ELSE
        invoke DefWindowProc, penYnt, kMesaj, pPrm, sPrm
        ret
    .ENDIF
    xor eax,eax
    ret
WndProc endp

end ana