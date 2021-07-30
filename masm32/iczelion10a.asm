; iczelion10a.asm: Men� penceresi ve ba��ms�z diyalog penceresinin uyumlulu�u �rne�i.
;
; ml  /c  /coff iczelion10a.asm
; rc iczelion10a.rc
; link /subsystem:windows iczelion10a.obj iczelion10a.res
; iczelion10a
;----------------------------------------------------------------------------------------------------------------------------------------
; ====10a.D�YALOG PENCERES�====
; Main ana pencerede 'CLASS "DLGCLASS"' ile diyalog penceresi ana pencere olarak tan�mlan�r. Diyalo�un konum ve
; ebatlar�, EDIT/DUZELT, BUTTON/SELAM ve BUTTON/��k�� konum ve ebatlar�  BEGIN-END d�ng�s�nde tan�mlan�r.
; Pencere men�s� Men� ad�yla ve BEGIN-END aras�nda MENUITEM: Metin��kt�s�, MetinSilme, ��k�� sat�rlar� tan�mlan�r.
; WindMain'de DLGWINDOWEXTRA ve s�n�f ad�:DLGCLASS verilir; ilk ��kan diyalog men� zemin rengi mavi yap�l�r.
; WindProc metodunda ise diyalog penceresi ve men� penceresinin invoke ba�vurular� detayland�r�l�r.
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "DLGCLASS", 0
    MenuAdi db "BenimMenu", 0
    DiyalogAdi db "BenimDiyalog", 0
    UygulamaAdi db "Diyalog Kutusu Uygulamas�", 0
    SelamMesaji db "Vayy! �imdi de d�zenleme kutusunday�m.", 0

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
    mov   ps.hbrBackground, COLOR_BTNFACE+15	; Sadece ilk pencere mavile�mekte, sonradan f�rlat�lanlar varsay�l� beyaz olmakta
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