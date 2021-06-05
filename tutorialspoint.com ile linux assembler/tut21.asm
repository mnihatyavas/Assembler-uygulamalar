; tut21.asm: Ascii 256 karakterleri ardýþýk þekilde altrutine yazdýrma örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===ALTRUTÝN ve YIÐIN VERÝ YAPISI===
; Yýðýn bellekte dizin benzeri veri saklamakta kullanýlan PUSH ile konulan, POP ile alýnan LIFO/LastInFirtOut
; tepeden iþleyen yapýdýr. Yýðýn aktüel tepe adresini SS:SP (StackSegment:StackPointer) yada SS:ESP gösterir.
; Yýðýna kelime yada dw konur, byte deðil; bellekte adres tepeden alta azalýr; yýðýn tepe adresi son konulan kelimenin
; alçak byte'ýdýr. Koyma ve alma komutlarý:
; AX ve BX kayýtçý deðerleri yýðýna konulacak
; PUSH AX
; PUSH BX
; Artýk bu kayýtçýlar baþka amaçlarla kullanýlabilir
; MOV AX, DEÐER1
; MOV BX, DEÐER2
; MOV DEÐER3, AX
; MOV DEÐER4, BX
; Orijinal deðerleri yýðýndan alalým
; POP BX
; POP AX
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    call göster	; altrutin çaðrýlýr, ret ile geridönülür
    mov eax,1	; 1=çýk
    int 0x80

göster:
    mov ecx, 256	; sayaç, ascii karakter sayýsý
birsonraki_karakter:
    push ecx	; aktüel döngü sayýsýný yýðýna koy
    mov eax, 4
    mov ebx, 1
    mov ecx, Karakter	; ilkanda ascii "0" yazýlacak
    mov edx, 1
    int 80h

    pop ecx		; yýðýndan aktüel döngü sayýsýný geri al
    ;mov dx, [Karakter]
    ;cmp byte [Karakter], 0dh
    inc byte [Karakter]	; Ascii karakteri birartýr
    loop birsonraki_karakter	; sayaç sýfýrlanmamýþsa döngüye devam
    ret

	section .data
    Karakter db "0"