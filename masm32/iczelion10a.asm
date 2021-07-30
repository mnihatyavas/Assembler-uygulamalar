; iczelion10a.asm: Menü penceresi ve baðýmsýz diyalog penceresinin uyumluluðu örneði.
;
; ml  /c  /coff iczelion10a.asm
; rc iczelion10a.rc
; link /subsystem:windows iczelion10a.obj iczelion10a.res
; iczelion10a
;----------------------------------------------------------------------------------------------------------------------------------------
; ====10a.DÝYALOG PENCERESÝ====
; Main ana pencerede 'CLASS "DLGCLASS"' ile diyalog penceresi ana pencere olarak tanýmlanýr. Diyaloðun konum ve
; ebatlarý, EDIT/DUZELT, BUTTON/SELAM ve BUTTON/Çýkýþ konum ve ebatlarý  BEGIN-END döngüsünde tanýmlanýr.
; Pencere menüsü Menü adýyla ve BEGIN-END arasýnda MENUITEM: MetinÇýktýsý, MetinSilme, Çýkýþ satýrlarý tanýmlanýr.
; WindMain'de DLGWINDOWEXTRA ve sýnýf adý:DLGCLASS verilir; ilk çýkan diyalog menü zemin rengi mavi yapýlýr.
; WindProc metodunda ise diyalog penceresi ve menü penceresinin invoke baþvurularý detaylandýrýlýr.
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "DLGCLASS", 0
    MenuAdi db "BenimMenu", 0
    DiyalogAdi db "BenimDiyalog", 0
    UygulamaAdi db "Diyalog Kutusu Uygulamasý", 0
    SelamMesaji db "Vayy! Þimdi de düzenleme kutusundayým.", 0

	.data?
    tiplemeYonetimi HINSTANCE ?
    komutSatiri LPSTR ?
    tampon db 512 dup(?)

	.const
    D_DUZELT equ 11
    D_DUGME equ 12
    D_CIK equ 13
    M_METNICIKAR equ 21
    M_METNISIL equ 22
    M_CIK equ 23

	.code
ana:
    invoke GetModuleHandle, NULL
    mov tiplemeYonetimi, eax
    invoke GetCommandLine
    mov komutSatiri, eax
    invoke WinMain, tiplemeYonetimi, NULL, komutSatiri, SW_SHOWDEFAULT
    invoke ExitProcess, eax

WinMain proc tipYnt:HINSTANCE, tipYnt0:HINSTANCE, kmtStr:LPSTR, kmtGostr:DWORD
    LOCAL ps:WNDCLASSEX
    LOCAL mesaj:MSG
    LOCAL dylgYnt:HWND
    mov   ps.cbSize, SIZEOF WNDCLASSEX
    mov   ps.style, CS_HREDRAW or CS_VREDRAW
    mov   ps.lpfnWndProc, OFFSET WndProc
    mov   ps.cbClsExtra, NULL
    mov   ps.cbWndExtra, DLGWINDOWEXTRA
    push  tipYnt
    pop   ps.hInstance
    mov   ps.hbrBackground, COLOR_BTNFACE+15	; Sadece ilk pencere mavileþmekte, sonradan fýrlatýlanlar varsayýlý beyaz olmakta
    ;;mov   ps.hbrBackground, COLOR_WINDOW+9
    mov   ps.lpszMenuName, OFFSET MenuAdi
    mov   ps.lpszClassName, OFFSET SinifAdi
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov   ps.hIcon, eax
    mov   ps.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov   ps.hCursor, eax
    invoke RegisterClassEx, addr ps
    invoke CreateDialogParam, tiplemeYonetimi, ADDR DiyalogAdi, NULL, NULL, NULL
    mov   dylgYnt, eax
      invoke GetDlgItem, dylgYnt, D_DUZELT
    invoke SetFocus, eax    
    INVOKE ShowWindow, dylgYnt, SW_SHOWNORMAL
    INVOKE UpdateWindow, dylgYnt
    .WHILE TRUE
        INVOKE GetMessage, ADDR mesaj,NULL,0,0
        .BREAK .IF (! eax)
            invoke IsDialogMessage, dylgYnt, ADDR mesaj
            .if eax == FALSE
                INVOKE TranslateMessage, ADDR mesaj
                INVOKE DispatchMessage, ADDR mesaj
            .endif
    .ENDW
    mov eax, mesaj.wParam
    ret
WinMain endp

WndProc proc penYnt:HWND, kMesaj:UINT, pPrmtr:WPARAM, sPrmtr:LPARAM
    .if kMesaj == WM_CREATE
        invoke SetDlgItemText, penYnt, D_DUZELT, ADDR UygulamaAdi
    .ELSEIF kMesaj == WM_DESTROY
        invoke PostQuitMessage, NULL
    .ELSEIF kMesaj == WM_COMMAND
        mov eax, pPrmtr
        .IF sPrmtr == 0
            .IF ax == M_METNICIKAR
                invoke GetDlgItemText, penYnt, D_DUZELT, ADDR tampon, 512
                invoke MessageBox, NULL, ADDR tampon, ADDR UygulamaAdi, MB_OK
            .ELSEIF ax == M_METNISIL
                invoke SetDlgItemText, penYnt, D_DUZELT, NULL
            .ELSE	; .ELSEIF ax == M_CIK
                invoke DestroyWindow, penYnt
            .ENDIF
        .ELSE
            mov edx, pPrmtr
            shr edx, 16
            .IF dx == BN_CLICKED
                .IF ax == D_DUGME
                    invoke SetDlgItemText, penYnt, D_DUZELT, ADDR SelamMesaji
                        .ELSEIF ax == D_CIK
                    invoke SendMessage, penYnt, WM_COMMAND, M_CIK, 0
                .ENDIF
            .ENDIF
        .ENDIF
    .ELSE
        invoke DefWindowProc, penYnt, kMesaj, pPrmtr, sPrmtr
        ret 
    .ENDIF
    xor eax,eax
    ret
WndProc endp

end ana