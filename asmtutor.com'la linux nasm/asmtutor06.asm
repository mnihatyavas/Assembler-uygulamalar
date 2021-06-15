; asmtutor06.asm: Mesaj sonlarýna ascii 0/null byte'ýnýn eklenmesi örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Dizge sonuna ascii 0/null sonlandýrýcý byte ekli ilk mesaj.
; 
Dizge sonuna ascii 0/null sonlandýrýcý byte ekli ikinci mesaj.
;----------------------------------------------------------------------------------------------------------------------------------
; ===6.Hiç Sonlandýrýcý Byte===
; Altrutinde mesaj uzunluðu karþýlaþtýrmasý null/hiç ascii 0 ile yapýldýðýndan, bunun mesaj sonuna 0H ile
; eklenmesi muhtemel hatalarý önler.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj1 db "Dizge sonuna ascii 0/null sonlandýrýcý byte ekli ilk mesaj.", 0Ah, 0h
    Mesaj2 db "Dizge sonuna ascii 0/null sonlandýrýcý byte ekli ikinci mesaj.", 0Ah, 0h

	SECTION .text
    global _start
_start:
    mov eax, Mesaj1
    call dyaz	; yaz altrutini önce uzunluk altrutinini çaðýrýr/döner
    mov eax, Mesaj2
    call dyaz	; DizgeYAZ
    call son