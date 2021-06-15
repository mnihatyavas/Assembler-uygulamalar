; asmtutor32.asm: SYS_SOCKETCALL ile yarat�lan, ba�lanan, dinleyen soketin gelen TCP taleplerini kabul �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
;----------------------------------------------------------------------------------------------------------------------------------
; ===32.Yarat�l�p, Ba�lanan, Dinleyen Soketin Kabul�===
; EBX=5, ECX=Arg�manlar�n y���ndaki adresi: ESP, EAX=102=SYS_SOCKETCALL
; Bir DOS komut sat�r�ndan bu program�n exe'sini �al��t�r�rken, ikinci DOS penceresinden "sudo netstat -plnt"
; �al��t�rarak 9001 kap�y� dinleyen soketi g�zle...
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

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

_son:
    call son