; nasm010.asm: Harici dosya rutinleriyle ekrana mesaj yans�tma �rne�i.
;
; nasm -fwin32 nams010.asm
; gcc -m32 nasm019.obj
;--------------------------------------------------------------------------------------------------------------------
			; Ekran Mesaj�, 32 bit
    SIFIR EQU 0		; �lk de�erli sabitler
    STD_�IKTI_Y�NET�M� EQU -11

    extern _GetStdHandle@4	; Harici rutinlerin ithali
    extern _WriteFile@20
    extern _ExitProcess@4

    global _main		; Programa giri� noktas�n�n ihrac�

	section .data	; Veri b�l�m�ndeki ilk de�erli de�i�kenler
    Mesaj db "Ekran Mesaj� 32 (uzunlu�u kendisi hesaplamakta)", 0Dh, 0Ah
    Mesaj�nUzunlu�u  EQU $ - Mesaj

	section .bss	; �lk de�ersiz de�i�kenler b�l�m�
    StardartY�netim resd 1
    Yaz�ld� resd 1

	section .text	; Kodlama b�l�m�
_main:
    push  STD_�IKTI_Y�NET�M�
    call  _GetStdHandle@4
    mov dword [StardartY�netim], EAX

    push SIFIR		; 5.nci parametre
    push Yaz�ld�		; 4.nc� parametre
    push Mesaj�nUzunlu�u	; 3.nc� parametre
    push Mesaj		; 2.nci parametre
    push dword [StardartY�netim] ; 1.nci parametre
    call _WriteFile@20	; ��kt�ya disk dosyas�na y�nlendirmek istersen ">" kullan

    push  SIFIR
    call  _ExitProcess@4