; iczelion06.asm: Klavyeden girilen karakterin pencereden özel yazýfonlu yansýtýlmasý örneði.
;
; ml  /c  /coff iczelion06.asm
; link /subsystem:windows iczelion06.obj
; iczelion06
;----------------------------------------------------------------------------------------------------------------------------------------
; ====6.KLAVYEDEN GÝRÝÞ====
; Önce ARIAL, 150px ebatlý yazýfonuailesi seçiliyor, sonra klavyeden her girilen karakter kýrmýzý zemin üzeri
; sarý yazýyla konum (x,y)=(400,120)px'de açýkmavi zeminli pencerede yansýtýlýyor.
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "BasitPencereSýnýfý", 0
    UygulamaAdi db "Klavyeden Karakter Giriþi", 0
    YazifonuAdi db "arial", 0
    karakter WPARAM 41h    ; 41h=65 ascii="A" (büyükharfli ilkdeðer)

	.data?
    tiplemeYonetimi HINSTANCE ?
    komutSatiri LPSTR ?

	.code
ana:
    invoke GetModuleHandle, NULL
    mov tiplemeYonetimi, eax
    invoke GetCommandLine
    mov komutSatiri, eax
    invoke WinMain, tiplemeYonetimi, NULL, komutSatiri, SW_SHOWDEFAULT
    invoke ExitProcess, eax

WinMain proc tipYnt:HINSTANCE, tipYnt0:HINSTANCE, kmtStr:LPSTR, kmtGstr:DWORD
    LOCAL ps:WNDCLASSEX
    LOCAL mesaj:MSG
    LOCAL pYnt:HWND
    mov ps.cbSize, SIZEOF ps
    mov ps.style, CS_HREDRAW or CS_VREDRAW
    mov ps.lpfnWndProc, OFFSET WndProc	; Biralttaki baþvuru Metodu adresi
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
    .ELSEIF kMesaj == WM_CHAR	; Klavyeden karakter giriþi
        push pPrm
        pop karakter
        invoke InvalidateRect, penYnt, NULL, TRUE
    .ELSEIF kMesaj == WM_PAINT	; Girilen karakterin pencereye yazdýrýlmasý
        invoke BeginPaint, penYnt, ADDR by
        mov aiYnt, eax
        ; Karakter ebat:150x150px, koyuluk: 800, arial
        invoke CreateFont, 150,0, 0, 0, 800, 0, 0, 0, OEM_CHARSET, OUT_DEFAULT_PRECIS,\
           CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_SCRIPT, ADDR YazifonuAdi
        invoke SelectObject, aiYnt, eax
        mov fonYnt, eax
        RGB 255, 255, 0	; Sarý metin
        invoke SetTextColor, aiYnt, eax
        RGB 255, 0, 0		; Kýrmýzý zemin
        invoke SetBkColor, aiYnt, eax
        invoke TextOut, aiYnt, 400,120, ADDR karakter, 1	; 1 karakter, konum (x,y)=(400,120)px
        invoke EndPaint, penYnt, ADDR by
    .ELSE
        invoke DefWindowProc, penYnt, kMesaj, pPrm, sPrm
        ret
    .ENDIF
    xor eax,eax
    ret
WndProc endp

end ana