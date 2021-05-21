; pcasm3.asm: Girilen iki sayýdan büyüðünü, þartlý dallanmasýz saptayan örnek.
;
; nasm -fwin32 pcasm3.asm
; gcc -m32 asm_io.obj pcasm.c pcasm3.obj -o pcasm3.exe
;--------------------------------------------------------------------------------------------------------------------------------
;
; SHL/ShiftLeft: sola 1 bit kaydýrýr, SHR/ShiftRight: saða 1 bit kaydýrýr
; mov ax, 0C123H ==>1100 0001 0010 0011=C123
; shl ax, 1 ==>1000 0010 0100 0110, ax=8246, CF=1
; shr ax, 1 ==>0100 0001 0010 0011, ax=4123, CF=0
; shr ax, 1 ==>0010 0000 1001 0001, ax=2091H, CF=1
; mov ax, 0C123H
; shl ax, 2 ==>0000 0100 1000 1100, ax=048C, CF=1
; mov cl, 3
; shr ax, cl ==>0000 0000 1001 0001, ax=0091, CF=1
;
; Ýþaretsiz ondalýk sayýyý sola 1 kaydýrma 2 ile çarpma, 2 kaydýrma 4 ile çarpmadýr; saða kaydýrma ise bölmedir
; 1011Binary=11Decimal, 10110B=22D, 101100B=44D
;
; Ýþareli sayýlarda kullanýlan SAL/ShiftArithmeticLeft ve SAR/ShiftArithmeticRight, iþaretsiz SHL ve SHR
; gibidir, sadece SAR'da ensoldaki bit 1 ise saða kaydýrýp sola 0 deðil 1 konur. SAL ise, ensoldaki iþaret
; biti deðiþtirilmedikce SHL gibidir.
; mov ax, 0C123H ==>1100 0001 0010 0011=C123
; sal ax, 1 ==>1000 0010 0100 0110, ax=8246, CF=1
; sal ax, 1 ==>0000 0100 1000 1100, ax=048C, CF=1
; sar ax, 2 ==>0000 0001 0010 0011, ax=0123, CF=0
;
; ROL/RotateLeft ve ROR/RotateRight sola ve saða kaydýrýrken CF/CarryFlag taþmadaki bitleri de devridaimler
; mov ax, 0C123H ==>1100 0001 0010 0011=C123
; rol ax, 1 ==>1000 0010 0100 0111, ax=8247, CF=1, soldaki 1 biti saðdan devridaim yaptý
; rol ax, 1 ==>0000 0100 1000 1111, ax=048F, CF=1
; rol ax, 1 ==>0000 1001 0001 1110, ax=091E, CF=0
; ror ax, 2 ==>1000 0010 0100 0111, ax=8247, CF=1
; ror ax, 1 ==>1100 0001 0010 0011, ax=C123, CF=1
;
; RCL/RotateCarryLeft ve RCR/RotateCarryRight ise CF ile 16 deðil 17 biti devridaim yapar
; mov ax, 0C123H ==>1100 0001 0010 0011=C123
; clc (ClearCarry, CF=0)
; rcl ax, 1 ==>1000 0010 0100 0110, ax=8246, CF=1
; rcl ax, 1 ==>0000 0100 1000 1101, ax=048D, CF=1
; rcl ax, 1 ==>0000 1001 0001 1011, ax=091B, CF=0
; rcr ax, 2 ==>1000 0010 0100 0110, ax=8246, CF=1
; rcr ax, 1 ==>1100 0001 0010 0011, ax=C123, CF=0
;
; 32 bitlik EAX kayýtçýsýndaki 1 bit sayýsýný tespit etme örneði:
; mov bl, 0		; bl içeriði 1 olanlarýn sayýsýný içerecek
; mov ecx, 32	; ecx 32-->0 döngü sayacýdýr
; sayaç_döngüsü:
; shl eax, 1	; bir sola taþýma bayraðýna kaydýrýr, EAX eski deðer dönecekse (rol eax, 1) kullanýlýr
; jnc artýrmadan_geç ; JNC/JumpNotCarry, eðer CF==0, artýrma
; inc bl
; artýrmadan_geç:
; loop sayaç_döngüsü	; eðer ECX==0 ise döngüden çýk
;
; 4 adet bool iþlemcisi AND/VE, OR/VEYA, XOR/FARKLI, NOT/DEÐÝL
; Gerçeklik tablosu bu iþlemlerin ikili sonucunu gösterir
; mov ax, 0C123H ==>1100 0001 0010 0011=C123=AH:AL
; and ax, 82F6H     ==>1000 0010 1111 0110=> ax=8022
;
; mov ax, 0C123H ==>1100 0001 0010 0011=C123
; or ax, 0E831H     ==>1110 1000 0011 0001=> ax=E933
;
; mov ax, 0C123H ==>1100 0001 0010 0011=C123
; xor ax, 0E831H    ==>1110 1000 0011 0001=> ax=2912
;
; mov ax, 0C123H ==>1100 0001 0010 0011=C123
; not ax                    ==>0011 1110 1101 1100 =>ax=3EDC
;
; Karma örnekleme:
; mov ax, 0C123H ==>1100 0001 0010 0011=C123
; or ax, 8                    8=0000 0000 0000 1000
;                                ax=1100 0001 0010 1011 =>ax=C12B
; and ax, 0FFDFH ==>1111 1111 1101 1111
;                                ax=1100 0001 0000 1011 =>ax=C10B
; xor ax, 8000H       ==>1000 0000 0000 0000
;                                ax=0100 0001 0000 1011 =>ax=410B
; or ax, 0F00H        ==>0000 1111 0000 0000
;                                ax=0100 1111 0000 1011 =>ax=4F0B
; and ax, 0FFF0H  ==>0000 1111 1111 0000
;                                 ax=0100 1111 0000 0000 =>ax=4F00
; xor ax, 0F00FH     ==>1111 0000 0000 1111
;                                 ax=1011  1111 0000 1111 =>ax=BF0F
; xor ax, 0FFFFH     ==>1111 1111 1111 1111
;                                 ax= 0100 0000 1111 0000 =>ax=40F0
;
; xor eax, eax	; eax = 0 (mov eax, 0)'dan daha kullanýþlý
;--------------------------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"

	segment .data
    mesaj1 db "Bir -+tamsayý girin: ",0
    mesaj2 db "Baþkabir -+tamsayý daha girin: ", 0
    mesaj3 db "Girdiklerinizden büyüðü: ", 0

	segment .bss
    girilen1  resd 1		; Girilen ilk tamsayý

	segment .text
    global  _esas_kodlama
_esas_kodlama:
    enter 0,0		; Kurulum rutini
    pusha

    mov eax, mesaj1		; Ýlk dizge mesajý yaz
    call yaz_dizge
    call oku_tms		; Ýlk tamsayýyý oku
    mov [girilen1], eax

    mov eax, mesaj2		; Ýkinci dizge mesajý yaz
    call yaz_dizge
    call oku_tms		; Ýkinci tamsayýyý oku

    xor ebx, ebx		; ebx = 0
    cmp eax, [girilen1]		; Ýkinci tamsayýyý ilkiyle kýyasla
    setg bl			; SetGreater (ikinci > ilk) ise [ebx = (girilen2 > girilen1) ? 1:0]
    neg ebx		; ebx = (girilen2 > girilen1) ? FFFF : 0
    mov ecx, ebx		; ecx = (girilen2 > girilen1) ? FFFF : 0
    and ecx, eax		; ecx = (girilen2 > girilen1) ? girilen2 : 0
    not ebx			; ebx = (girilen2 > girilen1) ? 0 : FFFF
    and ebx, [girilen1]		; ebx = (girilen2 > girilen1) ? 0 : girilen1
    or ecx, ebx		; ecx = (girilen2 > girilen1) ? girilen2 : girilen1 ==>(ecx:maximum)

    mov eax, mesaj3		; Son dizge mesajý yaz
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hiç

    popa		; Son C'ye dönüþ iþlemleri
    mov eax, 0
    leave
    ret