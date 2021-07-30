; iczelion10b.asm: Sadece ba��ms�z diyalog penceresi metodu �rne�i.
;
; ml  /c  /coff iczelion10b.asm
; rc iczelion10b.rc
; link /subsystem:windows iczelion10b.obj iczelion10b.res
; iczelion10b
;----------------------------------------------------------------------------------------------------------------------------------------
; ====10b.D�YALOG PENCERES�====
; �kinci y�temde ana WinMain ve WndProc metodlar� kullan�lmay�p, do�rudan DlgProc metoduyla ayn� sonuca ula��lm��t�r.
; "DlgProc proto :DWORD,:DWORD,:DWORD,:DWORD" parametrik ba�vuru kal�b� "include iczelion01.asm"ye dahil
; edilmi�tir. RC dosyada sadece diyalog ad� kullan�lm��, s�n�f veya men� adlar� yerine "D_MENU 10" tan�m� hem diyalog
; penceresinde hem de men� tan�m ba�l���nda kullan�lm��t�r. Ana asm program� DlgProc diyalog metodunda if kMesaj
; kontrolleriyle diyalog penceresindeki ve men� se�eneklerindeki detaylar� ger�ekle�tirmi�tir.
; EDIT/D_DUZELT kutusu biraz uzat�ld���ndan Selam ve ��k d��me konumlar� da buna uygun olarak de�i�tirilmi�tir.
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    DiyalogAdi db "BenimDiyalogum", 0
    UygulamaAdi db "Diyalog Penceresi Uygulamas�", 0
    SelamMesaji db "Vayy! �uanda metin d�zeltme kutusunday�m.", 0

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
    invoke DialogBoxParam, tiplemeYonetimi, ADDR DiyalogAdi, NULL, addr DlgProc, NULL
    mov komutSatiri, eax
    invoke ExitProcess, eax

DlgProc proc tipYnt:HWND, kMesaj:UINT, pPrmtr:WPARAM, sPrmtr:LPARAM
    .IF kMesaj == WM_INITDIALOG
        invoke GetDlgItem, tipYnt, D_DUZELT
        invoke SetFocus, eax
    .ELSEIF kMesaj == WM_CLOSE
        invoke SendMessage, tipYnt, WM_COMMAND, M_CIK, 0
    .ELSEIF kMesaj == WM_COMMAND
        mov eax, pPrmtr
        .IF sPrmtr == 0
            .IF ax == M_METNICIKAR
                invoke GetDlgItemText,tipYnt, D_DUZELT, ADDR tampon, 512
                invoke MessageBox, NULL,ADDR tampon, ADDR UygulamaAdi, MB_OK
            .ELSEIF ax == M_METNISIL
                invoke SetDlgItemText, tipYnt, D_DUZELT, NULL
            .ELSEIF ax == M_CIK
                invoke EndDialog, tipYnt, NULL
            .ENDIF
        .ELSE
            mov edx, pPrmtr
            shr edx, 16
            .if dx == BN_CLICKED
                .IF ax == D_DUGME
                    invoke SetDlgItemText, tipYnt, D_DUZELT, ADDR SelamMesaji
                        .ELSEIF ax == D_CIK
                    invoke SendMessage, tipYnt, WM_COMMAND, M_CIK, 0
                .ENDIF
            .ENDIF
        .ENDIF
    .ELSE
        mov eax, FALSE
        ret
    .ENDIF
    mov eax,TRUE
    ret
DlgProc endp

end ana