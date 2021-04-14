; nasm009.asm: Win32 mesaj kutusuyla programdan ��k���n onaylanmas� �rne�i.
;--------------------------------------------------------------------------------------------------------------------
	; Message Box, 32 bit. V1.01
    SIFIR EQU 0                             ; Constants
    MK_VARSAYKUTU1 EQU 0
    MK_VARSAYKUTU2 EQU 100h
    DEVAMNO EQU 7
    MK_EVETHAYIR EQU 4

    extern _MessageBoxA@16	; Harici rutinlerin ithali
    extern _ExitProcess@4	; Windows API (ret/��k��) fonksiyonu

    global _main		; Programa giri� noktas�

	section .data	; �lk de�erli veriler b�l�m�
   MesajKutuMetni    db "Program� sonland�rmak istiyor musun?", 0
   MesajKutuBa�l��� db "Mesaj Kutusu 32", 0

	section .text	; Program kodlama b�l�m�
_main:
   push  MK_EVETHAYIR | MK_VARSAYKUTU2
   push  MesajKutuBa�l���	; 3.nc�parametre
   push  MesajKutuMetni	; 2.nci parametre
   push SIFIR		; 1.nci parametre
   call  _MessageBoxA@16

   cmp EAX, DEVAMNO	; Cevab�n "Hay�r" durumunda programa devam kontrolu
   je _main

   push SIFIR
   call  _ExitProcess@4