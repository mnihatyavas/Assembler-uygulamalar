; iczelion04.asm: Yaratýlan pencereye metin boyama örneði.
;
; ml  /c  /coff iczelion04.asm	; /c sadece compile/derle (link .exe yapma), /coff .obj'ye derle
; link /subsystem:windows iczelion04.obj
; iczelion04
;----------------------------------------------------------------------------------------------------------------------------------------
; ===4.PENCEREYE METÝN BOYAMA===
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm    ; Standart komutlar dosyasý

	.data
    SinifAdi db "BasitPencereSýnýfý", 0	; "INVOKE CreateWindowEx" argümaný
    UygulamaAdi db "Bizim Ýkinci Penceremiz", 0	; "INVOKE CreateWindowEx" argümaný
    Metnimiz  db " Win32 assembler 'METÝN BOYAMA' muhteþem ve kolay! ", 0	; "invoke DrawText" argümaný

	.data?
    tiplemeYonetimi HINSTANCE ?	; "invoke WinMain" argümaný
    komutSatiri LPSTR ?		; "invoke WinMain" argümaný

	.code
ana:
    invoke GetModuleHandle, NULL	; Baþvur: ModülYönetiminiAl
    mov tiplemeYonetimi, eax		; Döneni aktar
    invoke GetCommandLine		; Baþvur: KomutSatýrýnýAl
    mov komutSatiri, eax		; Döneni aktar
    invoke WinMain, tiplemeYonetimi, NULL, komutSatiri, SW_SHOWDEFAULT
    invoke ExitProcess, eax

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
    LOCAL ps:WNDCLASSEX
    LOCAL mesaj:MSG
    LOCAL penYnt:HWND
    mov ps.cbSize, SIZEOF WNDCLASSEX
    mov ps.style, CS_HREDRAW or CS_VREDRAW
    mov ps.lpfnWndProc, OFFSET WndProc
    mov ps.cbClsExtra, NULL
    mov ps.cbWndExtra, NULL
    push hInst
    pop ps.hInstance
    mov ps.hbrBackground, COLOR_WINDOW+9	; Açýkmavi zeminrengi
    mov ps.lpszMenuName, NULL
    mov ps.lpszClassName, OFFSET SinifAdi
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov ps.hIcon, eax
    mov ps.hIconSm, 0
    invoke LoadCursor, NULL, IDC_ARROW
    mov ps.hCursor, eax
    invoke RegisterClassEx, addr ps
    INVOKE CreateWindowEx, NULL, ADDR SinifAdi, ADDR UygulamaAdi, WS_OVERLAPPEDWINDOW,\
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInst, NULL
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

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    LOCAL hdc:HDC	; handle device context
    LOCAL ps:PAINTSTRUCT
    LOCAL rect:RECT
    .IF uMsg == WM_DESTROY
        invoke PostQuitMessage, NULL
    .ELSEIF uMsg == WM_PAINT	; Pencere boyama mesajý
        ; Baþvurular: BeginPath, GetClientRect, DrawText, EndPaint
        invoke BeginPaint, hWnd, ADDR ps
        mov hdc, eax
        invoke GetClientRect, hWnd, ADDR rect
        ; DrawText proto hdc:HDC, lpString:DWORD, nCount:DWORD, lpRect:DWORD, uFormat:DWORD
        ; nCount: Yazdýrýlacak karaktersayýsý, yada NULL=-1
        invoke DrawText, hdc, ADDR Metnimiz, -1, ADDR rect, DT_SINGLELINE or DT_CENTER or DT_VCENTER
        invoke EndPaint, hWnd, ADDR ps
    .ELSE
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
        ret
    .ENDIF
    xor eax, eax
    ret
WndProc endp

end ana