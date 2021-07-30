; iczelion05.asm: Yaratýlan grafik pencereye renkli ve yazýfonlu metin boyama örneði.
;
; ml  /c  /coff iczelion05.asm
; link /subsystem:windows iczelion05.obj
; iczelion05
;----------------------------------------------------------------------------------------------------------------------------------------
; ====5.PENCEREYE METÝN BOYAMA-2====
; 32 bit RGB deðer yapýsý:
; RGB_value struct
;    unused   db 0
;    blue       db ?
;    green     db ?
;    red        db ?
; RGB_value ends
; Buna uygun RGB makro yaratýp deðerleri ters soldan saða EAX'a yerleiþtirilmelidir.
;
; Kullanýlacak yazýfonu parametreleri giriþi:
; CreateFont proto nHeight:DWORD,\	; Karakter yüksekliði, varsayýlý: 0
;    nWidth:DWORD,\		; Geniþliði, varsayýlý: 0
;    nEscapement:DWORD,\		; Karakter açýsal*10 dönmesi (0-->3600; 900:yukarýya, 1800:sola, 2700:aþaðýya)
;    nOrientation:DWORD,\		; Yönelim açýsý (0-->3600) çalýþmýyor!
;    nWeight:DWORD,\		; Aðýrlýðý/koyuluðu (0-->900)
;    cItalic:DWORD,\			; Herhangi deðerde yatýk, varsayýlý: 0
;    cUnderline:DWORD,\		; Altýçizili, varsayýlý: 0
;    cStrikeOut:DWORD,\		; Ortasýçizili, varsayýlý: 0
;    cCharSet:DWORD,\		; Karakterkümesi
;    cOutputPrecision:DWORD,\
;    cClipPrecision:DWORD,\
;    cQuality:DWORD,\		; Kalite (DEFAULT_QUALITY, PROOF_QUALITY, DRAFT_QUALITY)
;    cPitchAndFamily:DWORD,\		; Vurgu ve yazýfonu ailesi
;    lpFacename:DWORD		; Yazýfonu ailesi adresi
;
; invoke TextOut, hdc, 0,0, ADDR TestString, SIZEOF TestString 
; (x,y)=(0,0) yerine istenilen baþlangýç (saða,alta) px deðeri verilebilir
; SIZEOF metin ebatýný +1 fazla aldýðýndan eksiltilmelidir
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "BasitPencereSýnýfý", 0
    UygulamaAdi db "Bizim Üçüncü Penceremiz", 0
    MetinDizgesi db " Win32 assembler 'METiN BOYAMA-2' harika ve kolay! ", 0
    YazifonuAdi db "arial", 0	; script, verdana, arial

	.data?
    tiplemeYonetimi HINSTANCE ?	; tipleme: çoðaltma, numüne çýkarma, kopya alma
    komutSatiri LPSTR ?

	.code
ana:
    invoke GetModuleHandle, NULL
    mov tiplemeYonetimi, eax
    invoke GetCommandLine
    mov komutSatiri, eax
    invoke WinMain, tiplemeYonetimi, NULL, komutSatiri, SW_SHOWDEFAULT
    invoke ExitProcess, eax

WinMain proc tipYnt1:HINSTANCE, tipYnt0:HINSTANCE, kmtStr:LPSTR, kmtGstr:DWORD
    LOCAL ps:WNDCLASSEX	; PencereSýnýfý
    LOCAL mesaj:MSG
    LOCAL penYnt:HWND	; HandleWindow
    mov ps.cbSize, SIZEOF WNDCLASSEX
    mov ps.style, CS_HREDRAW or CS_VREDRAW
    mov ps.lpfnWndProc, OFFSET WndProc
    mov ps.cbClsExtra, NULL
    mov ps.cbWndExtra, NULL
    push tipYnt1
    pop ps.hInstance
    mov ps.hbrBackground, COLOR_WINDOW+4	; Siyah zeminrengi
    mov ps.lpszMenuName, NULL
    mov ps.lpszClassName, OFFSET SinifAdi
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov ps.hIcon, eax
    mov ps.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov ps.hCursor, eax
    invoke RegisterClassEx, addr ps
    INVOKE CreateWindowEx, NULL, ADDR SinifAdi, ADDR UygulamaAdi, WS_OVERLAPPEDWINDOW,\
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, tipYnt1, NULL
    mov penYnt, eax
    INVOKE ShowWindow, penYnt, SW_SHOWNORMAL
    INVOKE UpdateWindow, penYnt
    .WHILE TRUE
        INVOKE GetMessage, ADDR mesaj, NULL, 0, 0
        .BREAK .IF (!eax)
        INVOKE TranslateMessage, ADDR mesaj
        INVOKE DispatchMessage, ADDR mesaj
    .ENDW
    mov eax, mesaj.wParam
    ret
WinMain endp

WndProc proc penYnt:HWND, kMesaj:UINT, pPrm:WPARAM, sPrm:LPARAM
    LOCAL aiYnt: HDC	; HandleDeviceContext: AraçÝçeriðiYonetimi
    LOCAL by: PAINTSTRUCT	; BoyamaYapýsý
    LOCAL fonYnt: HFONT	; HandleFont: FonYonetimi
    .IF kMesaj == WM_DESTROY
        invoke PostQuitMessage, NULL
    .ELSEIF kMesaj == WM_PAINT
        invoke BeginPaint, penYnt, ADDR by
        mov aiYnt, eax
        invoke CreateFont, 24,17, 80, 0, 800, 1, 1, 1, OEM_CHARSET, OUT_DEFAULT_PRECIS,\
            CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_SCRIPT, ADDR YazifonuAdi
        invoke SelectObject, aiYnt, eax
        mov fonYnt, eax
        RGB 255, 255, 0	; Sarý metin
        invoke SetTextColor, aiYnt, eax
        RGB 255, 0, 0		; Kýrmýzý zemin
        invoke SetBkColor, aiYnt, eax
        invoke TextOut, aiYnt, 10,200, ADDR MetinDizgesi, SIZEOF MetinDizgesi - 1
        invoke SelectObject, aiYnt, fonYnt
        invoke EndPaint, penYnt, ADDR by
    .ELSE
        invoke DefWindowProc, penYnt, kMesaj, pPrm, sPrm
        ret
    .ENDIF
    xor eax, eax
    ret
WndProc endp

end ana