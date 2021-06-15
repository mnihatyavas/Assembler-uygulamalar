; asmtutor36.asm: SYS_SOCKETCALL ile uzak a�sunucuyla birle�ip a�sayfas�n� indirme �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Command terminated by signal 13
;----------------------------------------------------------------------------------------------------------------------------------
; ===36.Uzak A�sunucuyla Birle�me===
; ECX=Y���ndaki arg�manlar�n tepe adresi, EBX=3=CONNECT(3), EAX=102=SYS_SOCKETCALL
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm'

	SECTION .data
    Talep db "GET / HTTP/1.1", 0Dh, 0Ah, "Host: 139.162.39.66:80", 0Dh, 0Ah, 0Dh, 0Ah, 0h

	SECTION .bss
    tampon resb 1	; Yan�t'�n konuldu�u de�i�ken

	SECTION .text
    global _start
_start:
    xor eax, eax	; EAX=0
    xor ebx, ebx
    xor edi, edi

_soket:
    push byte 6	; Y���na koy (6=IPPROTO_TCP)
    push byte 1	; Y���na koy  (1=SOCK_STREAM)
    push byte 2	; Y���na koy (2=PF_INET)
    mov ecx, esp	; ECX=Arg�manlar�n y���ndaki tepe adresi
    mov ebx, 1	; Ba�vur SOCKET (1)
    mov eax, 102	; Ba�vur (102=SYS_SOCKETCALL)
    int 80h

_birle�:		; ba�lan/bind=2 de�il, birle�/connect=3
    mov edi, eax	; Hedef EDI=DTN/DosyaTasvirNo
    push dword 0x4227a28b	; Y���na koy (IP adres: 139.162.39.66; tersten 8bh=139, a2h=162, 27h=39, 42h=66)
    push word 0x5000	; Y���na koy (Kap� no: 80; tersten 0050h=80)
    push word 2		; Y���na koy (2=AF_INET)
    mov ecx, esp
    push byte 16		; Y���na koy (16=arg�man uzunlu�u)
    push ecx		; Arg�manlar�n adresi
    push edi		; DTN
    mov ecx, esp		; ECX=Arg�manlar�n y���n tepe adresi
    mov ebx, 3		; Ba�vur CONNECT (3)=Birle�
    mov eax, 102		; Ba�vur (102=SYS_SOCKETCALL)
    int 80h

_yaz:
    mov edx, 43	; Yaz�lacak byte uzunlu�u
    mov ecx, Talep	; Talep'imizin bellek adresi
    mov ebx, edi	; DTN
    mov eax, 4	; Ba�vur (4=SYS_WRITE)
    int 80h

_oku:
    mov edx, 1	; Okunacak byte say�s� (her kerede 1 byte)
    mov ecx, tampon	; Okunan dizgenin konulaca�� bellek de�i�keni
    mov ebx, edi	; DTN
    mov eax, 3	; Ba�vur (3=SYS_READ)
    int 80h

    cmp eax, 0
    jz _kapa	; Okunaca��n sonuysa _kapa'ya atla

    mov eax, tampon	; Tampon'daki byte yazd�r�lacak
    call dyaz
    jmp _oku	; Sonraki byte okunacak

_kapa:
    mov ebx, edi	; DTN
    mov eax, 6	; Ba�vur (6=SYS_CLOSE)
    int 80h

_son:
    call son