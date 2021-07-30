; iczelion03.asm: Basit ve boþ bir windows pencere yaratma örneði.
;
; ml  /c  /coff iczelion03.asm
; link /subsystem:windows iczelion03.obj
; iczelion03
;----------------------------------------------------------------------------------------------------------------------------------------
; ===3.BASÝT BÝR PENCERE===
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm	; Standart komutlar dosyasý
    WinMain proto :DWORD, :DWORD, :DWORD, :DWORD

	.data
    SinifAdi db "BasitPencereSýnýfý", 0
    UygulamaAdi db "Bizim Ýlk Penceremiz", 0

	.data?
    tiplemeYonetimi HINSTANCE ?	; DWORD çeþidi
    KomutSatiri LPSTR ?		; DWORD çeþidi

	.code
ana:	; Ana program (ana: ... end ana)
    invoke GetModuleHandle, NULL	; Baþvur
    mov tiplemeYonetimi, eax		; Döneni deðiþkene taþý
    invoke GetCommandLine
    mov KomutSatiri, eax
    invoke WinMain, tiplemeYonetimi, NULL, KomutSatiri, SW_SHOWDEFAULT
    invoke ExitProcess, eax		; Çýkýþ baþvurusu

; Altprogramlar: (WinMain: ... WinMain endp)
WinMain proc tipYnt:HINSTANCE, onceTipYnt:HINSTANCE, KmtStr:LPSTR, KmtGoster:DWORD
    LOCAL ps:WNDCLASSEX
    LOCAL mesaj:MSG
    LOCAL penYnt:HWND
    mov ps.cbSize, SIZEOF WNDCLASSEX
    mov ps.style, CS_HREDRAW or CS_VREDRAW
    mov ps.lpfnWndProc, OFFSET WndProc
    mov ps.cbClsExtra, NULL
    mov ps.cbWndExtra, NULL
    push tiplemeYonetimi
    pop ps.hInstance
    mov ps.hbrBackground, COLOR_WINDOW+9	; 1:beyaz, 2:gri, 4:siyah, 9:açýkmavi
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
    mov penYnt, eax
    invoke ShowWindow, penYnt, SW_SHOWNORMAL
    invoke UpdateWindow, penYnt
    .WHILE TRUE	; (.while true ... .endw)
        invoke GetMessage, ADDR mesaj, NULL, 0, 0
        .BREAK .IF (!eax)
        invoke TranslateMessage, ADDR mesaj
        invoke DispatchMessage, ADDR mesaj
    .ENDW
    mov eax, mesaj.wParam
    ret
WinMain endp

; Altprogram (WndProc ... WndProc endp)
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .IF uMsg == WM_DESTROY
        invoke PostQuitMessage, NULL
    .ELSE
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam        
        ret
    .ENDIF
    xor eax, eax
    ret
WndProc endp

end ana