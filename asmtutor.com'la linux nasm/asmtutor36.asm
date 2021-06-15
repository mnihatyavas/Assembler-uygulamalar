; asmtutor36.asm: SYS_SOCKETCALL ile uzak aðsunucuyla birleþip aðsayfasýný indirme örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Command terminated by signal 13
;----------------------------------------------------------------------------------------------------------------------------------
; ===36.Uzak Aðsunucuyla Birleþme===
; ECX=Yýðýndaki argümanlarýn tepe adresi, EBX=3=CONNECT(3), EAX=102=SYS_SOCKETCALL
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm'

	SECTION .data
    Talep db "GET / HTTP/1.1", 0Dh, 0Ah, "Host: 139.162.39.66:80", 0Dh, 0Ah, 0Dh, 0Ah, 0h

	SECTION .bss
    tampon resb 1	; Yanýt'ýn konulduðu deðiþken

	SECTION .text
    global _start
_start:
    xor eax, eax	; EAX=0
    xor ebx, ebx
    xor edi, edi

_soket:
    push byte 6	; Yýðýna koy (6=IPPROTO_TCP)
    push byte 1	; Yýðýna koy  (1=SOCK_STREAM)
    push byte 2	; Yýðýna koy (2=PF_INET)
    mov ecx, esp	; ECX=Argümanlarýn yýðýndaki tepe adresi
    mov ebx, 1	; Baþvur SOCKET (1)
    mov eax, 102	; Baþvur (102=SYS_SOCKETCALL)
    int 80h

_birleþ:		; baðlan/bind=2 deðil, birleþ/connect=3
    mov edi, eax	; Hedef EDI=DTN/DosyaTasvirNo
    push dword 0x4227a28b	; Yýðýna koy (IP adres: 139.162.39.66; tersten 8bh=139, a2h=162, 27h=39, 42h=66)
    push word 0x5000	; Yýðýna koy (Kapý no: 80; tersten 0050h=80)
    push word 2		; Yýðýna koy (2=AF_INET)
    mov ecx, esp
    push byte 16		; Yýðýna koy (16=argüman uzunluðu)
    push ecx		; Argümanlarýn adresi
    push edi		; DTN
    mov ecx, esp		; ECX=Argümanlarýn yýðýn tepe adresi
    mov ebx, 3		; Baþvur CONNECT (3)=Birleþ
    mov eax, 102		; Baþvur (102=SYS_SOCKETCALL)
    int 80h

_yaz:
    mov edx, 43	; Yazýlacak byte uzunluðu
    mov ecx, Talep	; Talep'imizin bellek adresi
    mov ebx, edi	; DTN
    mov eax, 4	; Baþvur (4=SYS_WRITE)
    int 80h

_oku:
    mov edx, 1	; Okunacak byte sayýsý (her kerede 1 byte)
    mov ecx, tampon	; Okunan dizgenin konulacaðý bellek deðiþkeni
    mov ebx, edi	; DTN
    mov eax, 3	; Baþvur (3=SYS_READ)
    int 80h

    cmp eax, 0
    jz _kapa	; Okunacaðýn sonuysa _kapa'ya atla

    mov eax, tampon	; Tampon'daki byte yazdýrýlacak
    call dyaz
    jmp _oku	; Sonraki byte okunacak

_kapa:
    mov ebx, edi	; DTN
    mov eax, 6	; Baþvur (6=SYS_CLOSE)
    int 80h

_son:
    call son