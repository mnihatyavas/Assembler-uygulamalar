; asmtutor35.asm: SYS_SOCKETCALL ile yarat�lan, ba�lanan, dinleyen, kabuleden, okuyan, yazan soketin kapat�lmas� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
;----------------------------------------------------------------------------------------------------------------------------------
; ===35.Yarat�l�p, Ba�lanan, Dinleyen, Kabuleden, Okuyan, Yazan Soketin Kapat�lmas�===
; Verilen yan�t sonras�, yavru i�lemciye yap�labilecek yeni ba�lant�lar i�in aktif soketin kapat�lmas� gerekti�inde
; EBX=DTN, EAX=6=sys_close
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Yan�t db "HTTP/1.1 200 OK", 0Dh, 0Ah, "Content-Type: text/html", 0Dh, 0Ah, "Content-Length: 14", 0Dh, 0Ah, 0Dh, 0Ah, "Hello World!", 0Dh, 0Ah, 0h

	SECTION .bss
    tampon resb 255	; Talep ba�l�klar�n� depolayan bellek de�i�keni

	SECTION .text
    global _start
_start:
    xor eax, eax	; Kay�t��lar s�f�rlan�r
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

_ba�lan:
    mov edi, eax	; yarat�lan soket d�nen de�eri DestinatioIndex'e
    push dword 0x00000000	; Kullan�c� IP ADDRESS (0.0.0.0)
    push word 0x2923	; Kullan�c� kap� no 9001 desimal (ters)
    push word 2		; Desimal 2=AF_INET
    mov ecx, esp	; Y���n tepe adresi
    push byte 16	; 16=y���ndaki arg�manlar�n uzunlu�u
    push ecx	; y���n tepe adresi
    push edi	; dosya tasvir no
    mov ecx, esp
    mov ebx, 2	; Ba�vur BIND (2)
    mov eax, 102	; Ba�vur (102=SYS_SOCKETCALL)
    int 80h

_dinle:
    push byte 1	; azami kuyruk uzunlu�u arg�man�, y���na
    push edi	; Dosya tasvir no, y���na
    mov ecx, esp	; Y���ndaki arg�manlar�n tepe adresi
    mov ebx, 4	; Ba�vur LISTEN (4)
    mov eax, 102	; Ba�vur (102=SYS_SOCKETCALL)
    int 80h

_kabulet:
    push byte 0	; adres uzunlu�u=0
    push byte 0	; adres=0
    push edi	; Dosya tasvir no
    mov ecx, esp	; Arg�manlar�n y���ndaki tepe adresi
    mov ebx, 5	; Ba�vur ACCEPT (5)
    mov eax, 102	; Ba�vur (102=SYS_SOCKETCALL)
    int 80h 

_�atallan:
    mov esi, eax	; D�nen dosya tasvir no
    mov eax, 2	; Ba�vur 2=SYS_FORK
    int 80h

    cmp eax, 0	; sys_fork d�nen de�eri=0 ise yavru i�indeyizdir
    jz _oku		; Yavru i�inde oku'ya atla
    jmp _kabulet	; Ebeveyn i�lemde _kabulet'e atla

_oku:
    mov edx, 255	; Ba�tan 255 byte okunacak
    mov ecx, tampon	; Talep ba�l�k verileri bellek adresini ECX'e kopyala
    mov ebx, esi	; Soket DTN/DosyaTasvirNo'yu aktar
    mov eax, 3	; Ba�vur 3=SYS_READ
    int 80h

    mov eax, tampon
    call dyazAS	; tampon i�eriklerini g�relim

_yaz:
    mov edx, 78	; Yaz�lacak yan�t uzunlu�u (byte)
    mov ecx, Yan�t	; ��erikli yan�t dizgesi
    mov ebx, esi	; Kabul edilen soket no DTN
    mov eax, 4	; Ba�vur 4=SYS_WRITE

_kapa:
    mov ebx, esi	; DTN, kabuledilen aktif soket dosya tasvir no
    mov eax, 6	; Ba�vur 6=SYS_CLOSE
    int 80h

_son:
    call son