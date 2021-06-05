; tut06.asm: Kernel yazdýrma çaðrýsýnda kullanýlan 4 kayýtçý örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Evet
;--------------------------------------------------------------------------------------------------------------------------
; ===DEÐÝÞKENLER===
; D/Define direktifiyle istediðimiz kadar ilk deðerli/deðersiz bellek deðiþkenleri tanýmlayabiliriz.
; DB/DefineByte (1 byte), DW/DefineWord (2 byte), DD/DefineDoubleword (4 byte), DQ/DefineQuadword (8 byte),
; DT/DefineTenbyte (10 byte)
; Örnekler:
; tercih DB "e"
; sayý DW 3BH	; Hex sayý
; eksi_sayý DW -12345	; Ondalýk negatif
; büyük_sayý DQ 123456789
; gerçel_sayý1 DD 1.234
; gerçel_sayý2 DQ 123.456
;
; Ondalýk sayýlar ascii hex-onaltýlýða çevrilip depolanýr. Negatifler 2 tamlayýcýsý +1'e çevrilir. Kayan noktalýlar kýsa 32-bit
; yada uzun 64 bit olarak saklanýr.
;--------------------------------------------------------------------------------------------------------------------------

	section .data
    tercihin DB "Evet"

	section .text
    global _start
_start:
    mov edx,4	; DataRegister, mesaj uzunluðu
    mov ecx, tercihin	; CounterRegister, yazdýrýlacak mesaj
    mov ebx,1	; BaseRegister, yazdýrýlacak dosya no=1 (stdout)
    mov eax, 4	; AccumulatorRegister, sistem çaðýrma no=4 (sys_write: yaz)
    int 0x80		; Kernel çaðrýsý

    mov eax,1	; Sistem çaðýrma no=1 (sys_exit: çýk)
    int 0x80		; Kernel çaðrýsý