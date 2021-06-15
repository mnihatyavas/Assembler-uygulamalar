; asmtutor18.asm: Ýlk 100 sayýdaki üçe, beþe, hem üç hem beþe bölünenlerin tespiti örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; 1, 2, Üç, 4, Beþ, Üç, 7, 8, Üç, Beþ, 11, Üç, 13, 14, ÜçBeþ, 16, 17, Üç, 19, Beþ, Üç, 22, 23, Üç, Beþ, 26, Üç, 28, 29, ÜçBeþ, 31, 32, Üç, 34, Beþ, Üç, 37, 38, Üç, Beþ, 41, Üç, 43, 44, ÜçBeþ, 46, 47, Üç, 49, Beþ, Üç, 52, 53, Üç, Beþ, 56, Üç, 58, 59, ÜçBeþ, 61, 62, Üç, 64, Beþ, Üç, 67, 68, Üç, Beþ, 71, Üç, 73, 74, ÜçBeþ, 76, 77, Üç, 79, Beþ, Üç, 82, 83, Üç, Beþ, 86, Üç, 88, 89, ÜçBeþ, 91, 92, Üç, 94, Beþ, Üç, 97, 98, Üç, Beþ, 
;----------------------------------------------------------------------------------------------------------------------------------
; ===18.üçbeþ Oyunu===
; Program 1'den 100'e ECX sayacý artýrýp, üçe bölünyorsa Üç, beþe bölünüyorsa Beþ, herikisine bölünüyorsa
; ÜçBeþ, deðilse rakamýn kendisini yazacak.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Üç db "Üç", 0h
    Beþ db "Beþ", 0h
    Aralýk db ", ", 0h

	SECTION .text
    global _start
_start:
    mov edi, 0	; .üç_kontrolu ikili deðiþkeninin ilkdeðeri
    mov esi, 0	; .beþ_kontrolu ikili deðiþkeninin ilkdeðeri
    mov ecx, 0	; 100'lük sayacýn ilkdeðeri
birsonraki_sayý:
    inc ecx		; kontrol edilecek sayýlar sayacý birartýrýlýr
.üç_kontrolu:
    mov edx, 0	; Bölümden kalaný tutacak
    mov eax, ecx	; Sayaçtaki sayý bölüm için EAX'a taþýnýr
    mov ebx, 3	; Bölen 3 EBX'e taþýnýr
    div ebx		; EAX /=EBX
    mov edi, edx	; Bölüm kalaný EDI'ye taþýnýr
    cmp edi, 0	; Kalan sýfýr mý?
    jne .beþ_kontrolu	; Sýfýr deðilse .beþ_kontrolu'na atla
    mov eax, Üç	; Kalan sýfýrsa üçe bölünür mesajý yansýtýlacak
    call dyaz	; "Üç" yazýlacak
.beþ_kontrolu:
    mov edx, 0	; Bölüm kalaný kayýtçýsý sýfýrlanýr
    mov eax, ecx	; Aktüel sayý tekrar EAX'a aktarýlýr
    mov ebx, 5	; Bölen 5 EBX'e taþýnýr
    div ebx		; EAX /=EBX
    mov esi, edx	; Kalan ESI'ye taþýnýr
    cmp esi, 0	; Kalan sýfýr mý?
    jne .tamsayý_kontrolu	; Sýfýr deðilse .tamsayý_kontrolu'na atla
    mov eax, Beþ	; Sýfýrsa beþe bölünür mesajý yazýlacak
    call dyaz	; "Beþ" yazýlacak
.tamsayý_kontrolu:
;tamsayý_kontrolu:
    cmp edi, 0	; EDI 3'e bölüm kalanýný tutmakta
    je .devam	; "Üç" yazmýþsan sayý yazýlmayacak, atla
    cmp esi, 0	; ESI 5'e bölüm kalanýný tutmakta
    je .devam	; "Beþ" yazmýþsan sayý yazýlmayacak, atla
    mov eax, ecx	; Sayaçtaki aktüel sayý yazýlacak
    call tyaz	; Sayý'yý yaz
.devam:
    ;mov eax, 0Ah	; Altsatýra geçilecek
    ;push eax	; Yýðýna koy
    ;mov eax, esp	; Yýðýn göstergesini (altsatýr bilgi adresini) EAX'e taþý
    mov eax, Aralýk
    call dyaz
    ;pop eax	; Yýðýna konulaný sil
    cmp ecx, 100	; Sayaç=100?
    jne birsonraki_sayý	; Henüz deðilse tekrar döngü baþýna atla
    call son