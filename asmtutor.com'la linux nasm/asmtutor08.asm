; asmtutor08.asm: Altrutin �a��rma esnas�nda ge�irilen arg�manlar�n kontrolu �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Mesaj yazd�r�rken ge�irilen arg�manlar�n testi.
; 
./jdoodle
;----------------------------------------------------------------------------------------------------------------------------------
; ===8.Arg�manlar Ge�irme===
; Altprograma ka� arg�man ge�irilmi�se ECX sayac� bunu kaydeder (ilk ge�en fonksiyon ad�, ikincisiyse arg�man say�s�).
; Y���ndan ECX'i al�p, s�f�rlan�ncaya dek d�ng�yle EAX'� pop'layarak ge�en arg�manlar� yans�tabiliriz.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "Mesaj yazd�r�rken ge�irilen arg�manlar�n testi.", 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj
    call dyazAS
    pop ecx		; LIFO y���n �st�ndeki ilk de�er ge�irilen arg�man say�s�d�r
birsonraki_arguman:
    cmp ecx, 0h	; Ba�ka arg�man kald� m� kontrolu
    jz sonn
    pop eax	; Y���na konulan arg�man de�erini al
    call dyazAS	; Arg�man de�erini yanss�t
    dec ecx		; Arg�man say�s�s� sayac�n� bir d���r
    jmp birsonraki_arguman

sonn:
    call son