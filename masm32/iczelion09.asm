; iczelion09.asm: Haz�r selam� yada girilen metni buton t�klayarak mesaj kutusunda g�sterme �rne�i.
;
; ml  /c  /coff iczelion09.asm
; rc iczelion09.rc
; link /subsystem:windows iczelion09.obj iczelion09.res
; iczelion09
;----------------------------------------------------------------------------------------------------------------------------------------
; ====9.YAVRU PENCERELER====
; .rc dosyas� #define sabitleriyle, .asm'deki .const sabit de�i�ken adlar� farkl� da olabilir, esas olan kimlik numaralar�n�n uyu�mas�d�r.
; �nceden tan�ml� pencere s�n�flar�: button, edit, listbox, checkbox, radio button vs. Yavru pencere CreateWindow veya
; CreateWindowEx ile yarat�labilir. Yarat�lacak yavru eleman�n s�n�f ad� "button" ve "edit" olarak tan�mlanmal�, id-kimlik numaralar� da
; DUGME_NO ve DUZEN_NO olarak tan�mlan�p, bu altprogram�n invoke ba�vurusunda arg�mansal girilmelidir.
; Men� elemanlar�ndan GOSTER yada buton t�kland���nda MessageBox veya SendMessage ba�vurusuyla "edit" kutusundaki
; akt�el veriyle (null, selamlama metni yada girilen) harici mesaj penceresi, i�erilen mesaj uzunlu�una uygun ebatta yarat�lacakt�r.
; Her GOSTER/BUTTON_NO t�kland�kca ard���k mesaj pencereleri s�ralanacak; ya herbirini tek tek kapatmak, yada programdan
; ��karak t�m ana ve yavru pencereleri temizlemek gerekmektedir. De�i�ken tampon, d�zenleme kutusuna girilen metni saklar.
; Pencere yarat�l�rkenki CLIENTEDGE, ana yada d�zen yavru pencere alan�n� bat�k g�sterir.
; Mavi zeminli (+15) ana penceredeki edit/d�zen kutusu (x:50, y:75) konumda ve (en:400, boy:25) px'dir. Button/d��me
; eleman�nkiler ise (x:130, y:150) ve (en:140, boy:25) px olup, istedi�inizce de�i�tirebilirsiniz.
; Edit/d�zen penceresinin yarat�lmas� akabinde "SetFocus, penYntDuzen" imlecin ilk andan itibaren edit�r kutusu i�inde
; veri giri�ine haz�r beklenmesini sa�lar.
; D��me t�kland���nda penParam y�ksek/d���k byte kontroluyla bunun men� se�ene�i de�il buton t�klamas� oldu�unu anlar,
; SendMessage ba�vurulurken mesaj metni GOSTER_NO arg�man�yla edit�rden al�n�r.
; Edit�r i�eri�inin silinmesi "SetWindowText,NULL" ile sa�lan�rken, istenirse do�rudan edit�re dizge de atanabilir.
; Anapenceredeki TranslateMessage ba�vurusu, edit�re klavyeden girileni anlaml� ASCII dizgesine �evirir.
;----------------------------------------------------------------------------------------------------------------------------------------

    include iczelion01.asm

	.data
    SinifAdi db "BasitPencereS�n�f�", 0
    UygulamaAdi  db "Metin D�zenleme", 0
    MenuAdi db "DuzenMenusu", 0
    DugmeSinifAdi db "button", 0
    DugmeMetni db "�lk d��memi t�kla", 0
    DuzenSinifAdi db "edit", 0
    DuzenlenenMetin db "Vayy! �u'anda bir metin d�zenleyici kutu i�indeyim...", 0

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
    mov ps.hbrBackground, COLOR_BTNFACE+15	; a��kmavi pencere zemini
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
	; Pencere ebat� (en:500, boy:300)
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
            50, 75, 400, 25, penYnt, DUZEN_NO, tipYonetimi, NULL	; Edit�r kutu ayarlar�
        mov penYntDuzen, eax
        invoke SetFocus, penYntDuzen
        invoke CreateWindowEx, NULL, ADDR DugmeSinifAdi, ADDR DugmeMetni,\
            WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
            130, 150, 140, 25, penYnt, DUGME_NO, tipYonetimi, NULL	; Buton ayarlar�
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