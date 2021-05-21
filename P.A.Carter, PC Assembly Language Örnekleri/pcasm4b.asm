; pcas4b.asm: Altprogramlardan otomatik call-pusha/ret-popa ile dönülmesi örneði.
;
; nasm -fwin32 pcasm4b.asm
; gcc pcasm4b.obj pcasm.c asm_io.obj -o pcasm4b.exe
;---------------------------------------------------------------------------------------------------------------------------
;
; Yýðýna PUSH ile her eklenen dword adresle ESP yýðýn göstergeçi 4 azalýrken, POP ile her çýkerýlan ESP'e 4 ekler.
; push dword 1	; Yýðýnbaþý 1000h adrese 1dw deðeri eklenince ESP=1000h - 0004h = 0FFCh
; push dword 2	; Yýðýnbaþý 1000h adrese 2dw deðeri eklenince ESP=0FFCh-0004h=0FF8h
; push dword 3	; Yýðýnbaþý 1000h adrese 3dw deðeri eklenince ESP=0FF8h-0004h=0FF4h
; pop eax		; LIFO yýðýndan son sokulan çýkarýlýnca EAX = 3, ESP=0FF4h+0004h=0FF8h
; pop ebx		; Yýðýndan bir önceki çýkarýlýnca EBX=2, ESP=0FF8h+0004h=0FFCh
; pop ecx		; Yýðýndan sonuncu çýkarýlýnca ECX=1, ESP0FFCh+0004h=1000h
;
; PUSHA ile EAX, EBX, ECX, EDX, ESI, EDI, EBP kayýtçýlarý hepten sokulur,
; POPA ile ise hepten çýkarýlýr.
; CALL tamsayý_okuma_altprogramý ile otomatikmen PUSHA ile yýðýnlar sokulur ve gidilen altprogramdaki ilk
; RET ile de otomatikmen POPA çýkarýlýp dönüþ adresi bulunur. Þayet
; tamsayý_okuma_altprogramý:
; call oku_tms
; mov [ebx], eax
; push eax	; Otomatik yýðýna yeni adres sokuþu
; ret		; Otomatik POPA ile geridönüþü bulamayacak...
;---------------------------------------------------------------------------------------------------------------------------

%include "asm_io.inc"

	segment .data
    GiriþMesajý1 db "Ýlk tamsayýyý girin: ", 0		; 0 mesaj sonunu gösterir
    GiriþMesajý2 db "Ýkinci tamsayýyý girin: ", 0
    ÇýkýþMesajý1 db "Girdikleriniz: ", 0
    ÇýkýþMesajý2 db " ve ", 0
    ÇýkýþMesajý3 db " olup toplamlarý: ", 0

	segment .bss
    tamsayý1 resd 1		; 1dw'lük tamsayý saklama deðiþkenleri
    tamsayý2 resd 1

	segment .text
    global  _esas_kodlama
_esas_kodlama:
    enter 0,0
    pusha

    mov eax, GiriþMesajý1
    call yaz_dizge
    mov ebx, tamsayý1
    call tamsayý_okuma_altprogramý
    mov eax, GiriþMesajý2
    call yaz_dizge
    mov ebx, tamsayý2
    call tamsayý_okuma_altprogramý

    mov eax, [tamsayý1]
    add eax, [tamsayý2]
    mov ebx, eax

    mov eax, ÇýkýþMesajý1
    call yaz_dizge
    mov eax, [tamsayý1]
    call yaz_tms
    mov eax, ÇýkýþMesajý2
    call yaz_dizge
    mov eax, [tamsayý2]
    call yaz_tms
    mov eax, ÇýkýþMesajý3
    call yaz_dizge
    mov eax, ebx
    call yaz_tms
    call yaz_hiç

    popa
    ;;mov eax, 0
    leave                     
    ret

;---------------------------------------------------------------------------------------------------------------------------
tamsayý_okuma_altprogramý:
    call oku_tms
    mov [ebx], eax	; Okunan tamsayý ebx'teki tamsayý1/2 deðiþkenlerine konur
    ret