; asmtutor30.asm: SYS_SOCKETCALL ile yaratýlan soketi IP-adres ve sunucuya baðlama örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
;----------------------------------------------------------------------------------------------------------------------------------
; ===30.Soketi Kullanýcýya Baðlama===
; EBX=2, ECX=Argümanlarýn yýðýndaki adresi: ESP, EAX=102=SYS_SOCKETCALL
; IP adres=0.0.0.0, çýkýþ=0x2923=2329h=2*16**3+3*16**2+2*16+9=9001
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

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

_son:
    call son