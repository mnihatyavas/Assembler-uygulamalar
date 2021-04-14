; nasm009.asm: Win32 mesaj kutusuyla programdan çýkýþýn onaylanmasý örneði.
;--------------------------------------------------------------------------------------------------------------------
	; Message Box, 32 bit. V1.01
    SIFIR EQU 0                             ; Constants
    MK_VARSAYKUTU1 EQU 0
    MK_VARSAYKUTU2 EQU 100h
    DEVAMNO EQU 7
    MK_EVETHAYIR EQU 4

    extern _MessageBoxA@16	; Harici rutinlerin ithali
    extern _ExitProcess@4	; Windows API (ret/çýkýþ) fonksiyonu

    global _main		; Programa giriþ noktasý

	section .data	; Ýlk deðerli veriler bölümü
   MesajKutuMetni    db "Programý sonlandýrmak istiyor musun?", 0
   MesajKutuBaþlýðý db "Mesaj Kutusu 32", 0

	section .text	; Program kodlama bölümü
_main:
   push  MK_EVETHAYIR | MK_VARSAYKUTU2
   push  MesajKutuBaþlýðý	; 3.ncüparametre
   push  MesajKutuMetni	; 2.nci parametre
   push SIFIR		; 1.nci parametre
   call  _MessageBoxA@16

   cmp EAX, DEVAMNO	; Cevabýn "Hayýr" durumunda programa devam kontrolu
   je _main

   push SIFIR
   call  _ExitProcess@4