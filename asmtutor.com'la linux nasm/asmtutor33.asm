; asmtutor33.asm: SYS_SOCKETCALL ile yarat�lan, ba�lanan, dinleyen, kabuleden kullan�c�n�n okumas� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
;----------------------------------------------------------------------------------------------------------------------------------
; ===33.Yarat�l�p, Ba�lanan, Dinleyen, Kabuleden Soketin Okumas�===
; EAX=2=sys-fork ile �atallanmay� ba�latarak gelen mesajlar i�in oku'ya, de�ilse kabulet'e dalland�r�l�r.
; Okuma EAX=3=sys_read ile, EDX=255 byte uzunluk, ECX=tambon bellek adresi, EBX=ESI kaynak endeksindeki
; dosya tasvir no belirtilir.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

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

_son:
    call son