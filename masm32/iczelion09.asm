; iczelion09.asm: Hazýr selamý yada girilen metni buton týklayarak mesaj kutusunda gösterme örneði.
;
; ml  /c  /coff iczelion09.asm
; rc iczelion09.rc
; link /subsystem:windows iczelion09.obj iczelion09.res
; iczelion09
;----------------------------------------------------------------------------------------------------------------------------------------
; ====9.YAVRU PENCERELER====
; .rc dosyasý #define sabitleriyle, .asm'deki .const sabit deðiþken adlarý farklý da olabilir, esas olan kimlik numaralarýnýn uyuþmasýdýr.
; Önceden tanýmlý pencere sýnýflarý: button, edit, listbox, checkbox, radio button vs. Yavru pencere CreateWindow veya
; CreateWindowEx ile yaratýlabilir. Yaratýlacak yavru elemanýn sýnýf adý "button" ve "edit" olarak tanýmlanmalý, id-kimlik numaralarý da
; DUGME_NO ve DUZEN_NO olarak tanýmlanýp, bu altprogramýn invoke baþvurusunda argümansal girilmelidir.
; Menü elemanlarýndan GOSTER yada buton týklandýðýnda MessageBox veya SendMessage baþvurusuyla "edit" kutusundaki
; aktüel veriyle (null, selamlama metni yada girilen) harici mesaj penceresi, içerilen mesaj uzunluðuna uygun ebatta yaratýlacaktýr.
; Her GOSTER/BUTTON_NO týklandýkca ardýþýk mesaj pencereleri sýralanacak; ya herbirini tek tek kapatmak, yada programdan
; çýkarak tüm ana ve yavru pencereleri temizlemek gerekmektedir. Deðiþken tampon, düzenleme kutusuna girilen metni saklar.
; Pencere yaratýlýrkenki CLIENTEDGE, ana yada düzen yavru pencere alanýný batýk gösterir.
; Mavi zeminli (+15) ana penceredeki edit/düzen kutusu (x:50, y:75) konumda ve (en:400, boy:25) px'dir. Button/düðme
; elemanýnkiler ise (x:130, y:150) ve (en:140, boy:25) px olup, istediðinizce deðiþtirebilirsiniz.
; Edit/düzen penceresinin yaratýlmasý akabinde "SetFocus, penYntDuzen" imlecin ilk andan itibaren editör kutusu içinde
; veri giriþine hazýr beklenmesini saðlar.
; Düðme týklandýðýnda penParam yüksek/düþük byte kontroluyla bunun menü seçeneði deðil buton týklamasý olduðunu anlar,
; SendMessage baþvurulurken mesaj metni GOSTER_NO argümanýyla editörden alýnýr.
; Editör içeriðinin silinmesi "SetWindowText,NULL" ile saðlanýrken, istenirse doðrudan editöre dizge de atanabilir.
; Anapenceredeki TranslateMessage baþvurusu, editöre klavyeden girileni anlamlý ASCII dizgesine çevirir.
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "BasitPencereSýnýfý", 0
    UygulamaAdi  db "Metin Düzenleme", 0
    MenuAdi db "DuzenMenusu", 0
    DugmeSinifAdi db "button", 0
    DugmeMetni db "Ýlk düðmemi týkla", 0
    DuzenSinifAdi db "edit", 0
    DuzenlenenMetin db "Vayy! Þu'anda bir metin düzenleyici kutu içindeyim...", 0

	.data?
    tipYonetimi HINSTANCE ?
    komutSatiri LPSTR ?
    penYntDugme HWND ?
    penYntDuzen HWND ?
    tampon db 512 dup(?)

	.const
    DUGME_NO equ 1
    DUZEN_NO equ 2
    SELAM_NO equ 1
    SiL_NO equ 2
    GOSTER_NO equ 3
    CIK_NO equ 4

	.code
ana:
    invoke GetModuleHandle, NULL
    mov tipYonetimi, eax
    invoke GetCommandLine
    mov komutSatiri, eax
    invoke WinMain, tipYonetimi, NULL, komutSatiri, SW_SHOWDEFAULT
    invoke ExitProcess,eax

WinMain proc tipYnt:HINSTANCE, tipYnt0:HINSTANCE, kmtStr:LPSTR, kmtGstr:DWORD
    LOCAL ps:WNDCLASSEX
    LOCAL mesaj:MSG
    LOCAL penYnt:HWND
    mov ps.cbSize, SIZEOF ps
    mov ps.style, CS_HREDRAW or CS_VREDRAW
    mov ps.lpfnWndProc, OFFSET WndProc
    mov ps.cbClsExtra, NULL
    mov ps.cbWndExtra, NULL
    push tipYnt
    pop ps.hInstance
    mov ps.hbrBackground, COLOR_BTNFACE+15	; açýkmavi pencere zemini
    mov ps.lpszMenuName, OFFSET MenuAdi
    mov ps.lpszClassName, OFFSET SinifAdi
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov ps.hIcon, eax
    mov ps.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov ps.hCursor, eax
    invoke RegisterClassEx, addr ps
    INVOKE CreateWindowEx, WS_EX_CLIENTEDGE, ADDR SinifAdi, ADDR UygulamaAdi, \
        WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 500, 300, NULL, NULL, tipYnt, NULL
	; Pencere ebatý (en:500, boy:300)
    mov penYnt, eax
    INVOKE ShowWindow, penYnt, SW_SHOWNORMAL
    INVOKE UpdateWindow, penYnt
    .WHILE TRUE
        INVOKE GetMessage, ADDR mesaj, NULL, 0, 0
        .BREAK .IF (! eax)
        INVOKE TranslateMessage, ADDR mesaj
        INVOKE DispatchMessage, ADDR mesaj
    .ENDW
    mov eax, mesaj.wParam
    ret
WinMain endp

WndProc proc penYnt:HWND, kMesaj:UINT, penPrm:WPARAM, strPrm:LPARAM
    .IF kMesaj == WM_DESTROY
        invoke PostQuitMessage, NULL
    .ELSEIF kMesaj == WM_CREATE
        invoke CreateWindowEx, WS_EX_CLIENTEDGE, ADDR DuzenSinifAdi, NULL,\
            WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or ES_AUTOHSCROLL,\
            50, 75, 400, 25, penYnt, DUZEN_NO, tipYonetimi, NULL	; Editör kutu ayarlarý
        mov penYntDuzen, eax
        invoke SetFocus, penYntDuzen
        invoke CreateWindowEx, NULL, ADDR DugmeSinifAdi, ADDR DugmeMetni,\
            WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
            130, 150, 140, 25, penYnt, DUGME_NO, tipYonetimi, NULL	; Buton ayarlarý
        mov  penYntDugme, eax
    .ELSEIF kMesaj == WM_COMMAND
        mov eax, penPrm
        .IF strPrm == 0
            .IF ax == SELAM_NO
                invoke SetWindowText, penYntDuzen, ADDR DuzenlenenMetin
                invoke SendMessage, penYntDuzen, WM_KEYDOWN, VK_END, NULL
            .ELSEIF ax == SiL_NO
                invoke SetWindowText, penYntDuzen, NULL
            .ELSEIF ax == GOSTER_NO	; MessageBox=SendMessage
                invoke GetWindowText, penYntDuzen, ADDR tampon, 512
                invoke MessageBox, NULL, ADDR tampon, ADDR UygulamaAdi, MB_OK
            .ELSEIF ax == CIK_NO
                invoke DestroyWindow, penYnt
            .ENDIF
        .ELSE
            .IF ax == DUGME_NO
                shr eax, 16
                .IF ax == BN_CLICKED
                    invoke SendMessage, penYnt, WM_COMMAND, GOSTER_NO, 0
                .ENDIF
            .ENDIF
        .ENDIF
    .ELSE
        invoke DefWindowProc, penYnt, kMesaj, penPrm, strPrm
        ret
    .ENDIF
    xor eax, eax
    ret
WndProc endp

end ana