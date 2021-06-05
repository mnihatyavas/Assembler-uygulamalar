; tut13.asm: Kodlamayla girilen sayýnýn çift/tek-sayý olduðunun AND'le tespiti örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 8h çift sayýdýr!
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===MANTIKSAL KOMUTLAR===
; Mantýksal komutlar: AND/VE, OR/VEYA, XOR/FARKLIYSA iþlemci1 iþlemci2, TEST/TekÇift, NOT/DEÐÝL iþemci1
;  Kontrol bayraklarý: CF, OF, PF, SF, ZF
; AND BL, 0FH ; BL: 0011 1010, sonuç: 0000 1010
;
; AND AL, 01H ; 0000 0001 
; JZ ÇÝFT_SAYI ; AND sonucu sýfýrsa çift sayýdýr
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov ax, 8h	; çift sayý testi: 0000 1000
;    mov ax, 9h	; tek sayý testi: 0000 1001
    and ax, 1	; ZF=1
    jz çiftsayý	; çiftsayý etiketine atlar
    mov eax, 4
    mov ebx, 1
    mov ecx, Teksayý_mesajý
    mov edx, uzunluk2
    int 0x80
    jmp çýkýþ

çiftsayý:
    mov eax, 4
    mov ebx, 1
    mov ecx, Çiftsayý_mesajý
    mov edx, uzunluk1
    int 0x80

çýkýþ:
    mov eax,1
    int 0x80

	section .data
    Çiftsayý_mesajý db "8h çift sayýdýr!"
    uzunluk1 equ $ - Çiftsayý_mesajý
    Teksayý_mesajý db "9h tek sayýdýr!"
    uzunluk2 equ $ - Teksayý_mesajý