; tut09.asm: Klavyeden girilen 2 sayýnýn toplamýný yazdýrma örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Bir sayý girin: 3
; Bir sayý daha girin: 5
; Toplamlarý: 8
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===ARÝTMETÝK KOMUTLAR===
; Sayýsal sabitler için kullanýlan EQU (küçük/büyük-harfe duyarsýz) sabitleri program içinde deðiþtirilemezken
; %assign (küçük harfle yazýlmalýdýr) tahsisleri deðiþtirilebilir.
; %assign TOPLAM 10
; %assign TOPLAM 20	; sonradan deðiþtirildi
;
; %define, C'deki #define gibidir (harf duyarlý), sayýsal ve dizgesel sabitler için kullanýlýr, sonradan deðiþtirilebilir.
; %define ÝÞARETÇÝ [EBP+4]	; ebp+4 adresndeki deðer sabite kopyalanýr
;
; INC/Inrement/Birartýr, DEC/Decrement/Birazalt hedef (hedef -8,16, 32 bitli- kayýtçý yada bellek adresi/deðiþkeni)
; INC EBX	; ebx +=1 (32-bit temel kayýtçý)
; INC DL		; dl +=1 (8-bit kayýtçý)
; INC [sayaç]	; sayaç +=1
;
; segment .data
; sayaç dw 0
; deðer db 15
; segment .text
; inc [sayaç]
; dec [deðer]
; mov ebx, sayaç
; inc word [ebx]
; mov esi, deðer
; dec byte [esi]
;
; ADD/Add/Topla, SUB/Subtract/Çýkar hedef, kaynak (6-16, 32 bitli) kayýtçý, bellek, deðiþkenler arasýndadýr.
;----------------------------------------------------------------------------------------------------------------------------------------------

    ÇIK equ 1
    OKU equ 3
    YAZ equ 4
    KLAVYE equ 0
    EKRAN equ 1

	segment .data
    Mesaj1 db "Bir sayý girin: ", 0xA, 0xD
    Uzunluk1 equ $ - Mesaj1
    Mesaj2 db "Bir sayý daha girin: ", 0xA, 0xD
    Uzunluk2 equ $- Mesaj2
    Mesaj3 db "Toplamlarý: "
    Uzunluk3 equ $- Mesaj3

	segment .bss
    sayý1 resb 2
    sayý2 resb 2
    sonuç resb 1

	section .text
    global _start
_start:
    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, Mesaj1
    mov edx, Uzunluk1
    int 0x80

    mov eax, OKU
    mov ebx, KLAVYE
    mov ecx, sayý1
    mov edx, 2
    int 0x80

    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, Mesaj2
    mov edx, Uzunluk2
    int 0x80

    mov eax, OKU
    mov ebx, KLAVYE
    mov ecx, sayý2
    mov edx, 2
    int 0x80

    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, Mesaj3
    mov edx, Uzunluk3
    int 0x80

    mov eax, [sayý1]
    sub eax, "0"	; ascii'yi ondalýða çevirir
    mov ebx, [sayý2]
    sub ebx, "0"	; ascii'yi ondalýða çevirir
    add eax, ebx	; eax += ebx
    add eax, "0"	; ondalýðý ascii'ye çevirir
    mov [sonuç], eax

    mov eax, YAZ
    mov ebx, EKRAN
    mov ecx, sonuç
    mov edx, 1
    int 0x80

çýkýþ:
    mov eax, ÇIK
    xor ebx, ebx	; ebx=0
    int 0x80