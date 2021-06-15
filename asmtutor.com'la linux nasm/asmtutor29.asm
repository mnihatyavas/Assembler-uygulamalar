; asmtutor29.asm: SYS_SOCKETCALL ile sunucu-kullan�c� soketi yaratma �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 3
;----------------------------------------------------------------------------------------------------------------------------------
; ===29.Sunucu-Kullan�c� Soketi Yaratma===
; EBX=1, ECX=Arg�manlar�n y���ndaki adresi: ESP, EAX=102=SYS_SOCKETCALL
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .text
    global _start
_start:
    xor eax, eax	; farkl�ysa 1, de�ilse 0; kay�t��y� s�f�rlar
    xor ebx, ebx
    xor edi, edi
    xor esi, esi

_soket:
    push byte 6	; 6=IPPROTO_TCP
    push byte 1	; 1=SOCK_STREAM
    push byte 2	; 2=PF_INET
    mov ecx, esp	; y���n�n en�st adresi
    mov ebx, 1	; Ba�vur SOCKET (1)
    mov eax, 102	; Ba�vur (102=SYS_SOCKETCALL)
    int 80h

    call tyazAS	; EAX'daki d�nen dosya tasvir no

_son:
    call son