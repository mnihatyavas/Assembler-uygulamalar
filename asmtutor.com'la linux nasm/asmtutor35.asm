; asmtutor35.asm: SYS_SOCKETCALL ile yaratýlan, baðlanan, dinleyen, kabuleden, okuyan, yazan soketin kapatýlmasý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
;----------------------------------------------------------------------------------------------------------------------------------
; ===35.Yaratýlýp, Baðlanan, Dinleyen, Kabuleden, Okuyan, Yazan Soketin Kapatýlmasý===
; Verilen yanýt sonrasý, yavru iþlemciye yapýlabilecek yeni baðlantýlar için aktif soketin kapatýlmasý gerektiðinde
; EBX=DTN, EAX=6=sys_close
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Yanýt db "HTTP/1.1 200 OK", 0Dh, 0Ah, "Content-Type: text/html", 0Dh, 0Ah, "Content-Length: 14", 0Dh, 0Ah, 0Dh, 0Ah, "Hello World!", 0Dh, 0Ah, 0h

	SECTION .bss
    tampon resb 255	; Talep baþlýklarýný depolayan bellek deðiþkeni

	SECTION .text
    global _start
_start:
    xor eax, eax	; Kayýtçýlar sýfýrlanýr
    xor ebx, ebx
    xor edi, edi
    xor esi, esi

_soket:
    push byte 6
    push byte 1
    push byte 2
    mov ecx, esp
    mov ebx, 1	; 1=soket yarat
    mov eax, 102	; 102=sys_socketcall
    int 80h

_baðlan:
    mov edi, eax	; yaratýlan soket dönen deðeri DestinatioIndex'e
    push dword 0x00000000	; Kullanýcý IP ADDRESS (0.0.0.0)
    push word 0x2923	; Kullanýcý kapý no 9001 desimal (ters)
    push word 2		; Desimal 2=AF_INET
    mov ecx, esp	; Yýðýn tepe adresi
    push byte 16	; 16=yýðýndaki argümanlarýn uzunluðu
    push ecx	; yýðýn tepe adresi
    push edi	; dosya tasvir no
    mov ecx, esp
    mov ebx, 2	; Baþvur BIND (2)
    mov eax, 102	; Baþvur (102=SYS_SOCKETCALL)
    int 80h

_dinle:
    push byte 1	; azami kuyruk uzunluðu argümaný, yýðýna
    push edi	; Dosya tasvir no, yýðýna
    mov ecx, esp	; Yýðýndaki argümanlarýn tepe adresi
    mov ebx, 4	; Baþvur LISTEN (4)
    mov eax, 102	; Baþvur (102=SYS_SOCKETCALL)
    int 80h

_kabulet:
    push byte 0	; adres uzunluðu=0
    push byte 0	; adres=0
    push edi	; Dosya tasvir no
    mov ecx, esp	; Argümanlarýn yýðýndaki tepe adresi
    mov ebx, 5	; Baþvur ACCEPT (5)
    mov eax, 102	; Baþvur (102=SYS_SOCKETCALL)
    int 80h 

_çatallan:
    mov esi, eax	; Dönen dosya tasvir no
    mov eax, 2	; Baþvur 2=SYS_FORK
    int 80h

    cmp eax, 0	; sys_fork dönen deðeri=0 ise yavru içindeyizdir
    jz _oku		; Yavru içinde oku'ya atla
    jmp _kabulet	; Ebeveyn iþlemde _kabulet'e atla

_oku:
    mov edx, 255	; Baþtan 255 byte okunacak
    mov ecx, tampon	; Talep baþlýk verileri bellek adresini ECX'e kopyala
    mov ebx, esi	; Soket DTN/DosyaTasvirNo'yu aktar
    mov eax, 3	; Baþvur 3=SYS_READ
    int 80h

    mov eax, tampon
    call dyazAS	; tampon içeriklerini görelim

_yaz:
    mov edx, 78	; Yazýlacak yanýt uzunluðu (byte)
    mov ecx, Yanýt	; Ýçerikli yanýt dizgesi
    mov ebx, esi	; Kabul edilen soket no DTN
    mov eax, 4	; Baþvur 4=SYS_WRITE

_kapa:
    mov ebx, esi	; DTN, kabuledilen aktif soket dosya tasvir no
    mov eax, 6	; Baþvur 6=SYS_CLOSE
    int 80h

_son:
    call son