; tut18.asm: Be�er haneli iki say�n�n toplam� �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 12345 + 2345 = 35801
;----------------------------------------------------------------------------------------------------------------------------------------------
; SAYILAR-2===
; Paketsiz BCD/BinaryCodedDecimal'de 1234 depolanmas� 01-02-03-04H �eklinde ve AAA, AAS, AAM, AAD
; buradada aynen ge�erlidir.
; Paketli BCD'de 1234 depolanmas� 12-34H �eklinde ve sadece DAA/DecimalAdjustafterAddition ile DAS/
; DecimalAdjusafterSubtraction komutlar� kullan�l�r, �arpma ve b�lme desteklenmez.
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov esi, 4	; Say�1 ve Say�2'nin ensa� rakam�n� g�sterecektir
    mov ecx, 5	; 5 haneli rakamlar gere�i d�ng�y� 5 kere tekrarlayacakt�r
    clc		; ClearCarry
toplama_d�ng�s�:
    mov al, [Say�1 + esi]	; Say�1'in sa�dan sola tek tek rakamlar�n� AL'a ta��
    adc al, [Say�2 + esi]	; AL += [Say�2'nin sa�dan sola tek tek rakamlar�]
    aaa			; AsciiAdjustafterAddition
    pushf			; PushFlags
    or al, 30h		; OR ile say�y� 30H-->39H ascii'ye �evir (bayraklar etkilenebilir)
    popf			; PopFlags (�nceki bayrak de�erlerine d�n)
    mov [Toplam + esi], al	; AL toplam tek rakam�n� ilgili Toplam konumuna ta�� (CF=1 olabilir)
    dec esi			; Say�'lar�n sa�dan bir�ncekini g�ster
    loop toplama_d�ng�s�	; ECX s�f�r de�ilse d�ng� ba��na d�n

    mov edx, Uzunluk		; Mesaj uzunlu�u
    mov ecx, Mesaj		; Yazd�r�lacak Mesaj
    mov ebx,1		; 1=Ekran
    mov eax, 4		; 4=Yaz
    int 0x80			; Fonksiyonu ko�tur

    mov edx, 5		; Toplam uzunlu�u (5 byte)
    mov ecx, Toplam		; Yazd�r�lacak Toplam
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov eax,1		; 1=��k
    int 0x80

	section .data
    Mesaj db "12345 + 2345 = ", 0xa
    Uzunluk equ $ - Mesaj
    Say�1 db "12345"
    Say�2 db "23456"		; "98765" dene
    Toplam db "     "