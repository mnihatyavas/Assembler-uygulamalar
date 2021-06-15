; asmtutor29.asm: SYS_SOCKETCALL ile sunucu-kullanýcý soketi yaratma örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 3
;----------------------------------------------------------------------------------------------------------------------------------
; ===29.Sunucu-Kullanýcý Soketi Yaratma===
; EBX=1, ECX=Argümanlarýn yýðýndaki adresi: ESP, EAX=102=SYS_SOCKETCALL
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .text
    global _start
_start:
    xor eax, eax	; farklýysa 1, deðilse 0; kayýtçýyý sýfýrlar
    xor ebx, ebx
    xor edi, edi
    xor esi, esi

_soket:
    push byte 6	; 6=IPPROTO_TCP
    push byte 1	; 1=SOCK_STREAM
    push byte 2	; 2=PF_INET
    mov ecx, esp	; yýðýnýn enüst adresi
    mov ebx, 1	; Baþvur SOCKET (1)
    mov eax, 102	; Baþvur (102=SYS_SOCKETCALL)
    int 80h

    call tyazAS	; EAX'daki dönen dosya tasvir no

_son:
    call son