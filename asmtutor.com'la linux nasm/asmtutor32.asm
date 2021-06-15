; asmtutor32.asm: SYS_SOCKETCALL ile yaratýlan, baðlanan, dinleyen soketin gelen TCP taleplerini kabul örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
;----------------------------------------------------------------------------------------------------------------------------------
; ===32.Yaratýlýp, Baðlanan, Dinleyen Soketin Kabulü===
; EBX=5, ECX=Argümanlarýn yýðýndaki adresi: ESP, EAX=102=SYS_SOCKETCALL
; Bir DOS komut satýrýndan bu programýn exe'sini çalýþtýrýrken, ikinci DOS penceresinden "sudo netstat -plnt"
; çalýþtýrarak 9001 kapýyý dinleyen soketi gözle...
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

_son:
    call son