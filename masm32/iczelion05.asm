; iczelion05.asm: Yarat�lan grafik pencereye renkli ve yaz�fonlu metin boyama �rne�i.
;
; ml  /c  /coff iczelion05.asm
; link /subsystem:windows iczelion05.obj
; iczelion05
;----------------------------------------------------------------------------------------------------------------------------------------
; ====5.PENCEREYE MET�N BOYAMA-2====
; 32 bit RGB de�er yap�s�:
; RGB_value struct
;    unused   db 0
;    blue       db ?
;    green     db ?
;    red        db ?
; RGB_value ends
; Buna uygun RGB makro yarat�p de�erleri ters soldan sa�a EAX'a yerlei�tirilmelidir.
;
; Kullan�lacak yaz�fonu parametreleri giri�i:
; CreateFont proto nHeight:DWORD,\	; Karakter y�ksekli�i, varsay�l�: 0
;    nWidth:DWORD,\		; Geni�li�i, varsay�l�: 0
;    nEscapement:DWORD,\		; Karakter a��sal*10 d�nmesi (0-->3600; 900:yukar�ya, 1800:sola, 2700:a�a��ya)
;    nOrientation:DWORD,\		; Y�nelim a��s� (0-->3600) �al��m�yor!
;    nWeight:DWORD,\		; A��rl���/koyulu�u (0-->900)
;    cItalic:DWORD,\			; Herhangi de�erde yat�k, varsay�l�: 0
;    cUnderline:DWORD,\		; Alt��izili, varsay�l�: 0
;    cStrikeOut:DWORD,\		; Ortas��izili, varsay�l�: 0
;    cCharSet:DWORD,\		; Karakterk�mesi
;    cOutputPrecision:DWORD,\
;    cClipPrecision:DWORD,\
;    cQuality:DWORD,\		; Kalite (DEFAULT_QUALITY, PROOF_QUALITY, DRAFT_QUALITY)
;    cPitchAndFamily:DWORD,\		; Vurgu ve yaz�fonu ailesi
;    lpFacename:DWORD		; Yaz�fonu ailesi adresi
;
; invoke TextOut, hdc, 0,0, ADDR TestString, SIZEOF TestString 
; (x,y)=(0,0) yerine istenilen ba�lang�� (sa�a,alta) px de�eri verilebilir
; SIZEOF metin ebat�n� +1 fazla ald���ndan eksiltilmelidir
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "BasitPencereS�n�f�", 0
    UygulamaAdi db "Bizim ���nc� Penceremiz", 0
    MetinDizgesi db " Win32 assembler 'METiN BOYAMA-2' harika ve kolay! ", 0
    YazifonuAdi db "arial", 0	; script, verdana, arial

	.data?
    tiplemeYonetimi HINSTANCE ?	; tipleme: �o�altma, num�ne ��karma, kopya alma
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
    LOCAL ps:WNDCLASSEX	; PencereS�n�f�
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
    LOCAL aiYnt: HDC	; HandleDeviceContext: Ara���eri�iYonetimi
    LOCAL by: PAINTSTRUCT	; BoyamaYap�s�
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
        RGB 255, 255, 0	; Sar� metin
        invoke SetTextColor, aiYnt, eax
        RGB 255, 0, 0		; K�rm�z� zemin
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