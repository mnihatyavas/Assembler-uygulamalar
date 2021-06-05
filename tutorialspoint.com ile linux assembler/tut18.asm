; tut18.asm: Beþer haneli iki sayýnýn toplamý örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 12345 + 2345 = 35801
;----------------------------------------------------------------------------------------------------------------------------------------------
; SAYILAR-2===
; Paketsiz BCD/BinaryCodedDecimal'de 1234 depolanmasý 01-02-03-04H þeklinde ve AAA, AAS, AAM, AAD
; buradada aynen geçerlidir.
; Paketli BCD'de 1234 depolanmasý 12-34H þeklinde ve sadece DAA/DecimalAdjustafterAddition ile DAS/
; DecimalAdjusafterSubtraction komutlarý kullanýlýr, çarpma ve bölme desteklenmez.
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov esi, 4	; Sayý1 ve Sayý2'nin ensað rakamýný gösterecektir
    mov ecx, 5	; 5 haneli rakamlar gereði döngüyü 5 kere tekrarlayacaktýr
    clc		; ClearCarry
toplama_döngüsü:
    mov al, [Sayý1 + esi]	; Sayý1'in saðdan sola tek tek rakamlarýný AL'a taþý
    adc al, [Sayý2 + esi]	; AL += [Sayý2'nin saðdan sola tek tek rakamlarý]
    aaa			; AsciiAdjustafterAddition
    pushf			; PushFlags
    or al, 30h		; OR ile sayýyý 30H-->39H ascii'ye çevir (bayraklar etkilenebilir)
    popf			; PopFlags (önceki bayrak deðerlerine dön)
    mov [Toplam + esi], al	; AL toplam tek rakamýný ilgili Toplam konumuna taþý (CF=1 olabilir)
    dec esi			; Sayý'larýn saðdan biröncekini göster
    loop toplama_döngüsü	; ECX sýfýr deðilse döngü baþýna dön

    mov edx, Uzunluk		; Mesaj uzunluðu
    mov ecx, Mesaj		; Yazdýrýlacak Mesaj
    mov ebx,1		; 1=Ekran
    mov eax, 4		; 4=Yaz
    int 0x80			; Fonksiyonu koþtur

    mov edx, 5		; Toplam uzunluðu (5 byte)
    mov ecx, Toplam		; Yazdýrýlacak Toplam
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov eax,1		; 1=Çýk
    int 0x80

	section .data
    Mesaj db "12345 + 2345 = ", 0xa
    Uzunluk equ $ - Mesaj
    Sayý1 db "12345"
    Sayý2 db "23456"		; "98765" dene
    Toplam db "     "