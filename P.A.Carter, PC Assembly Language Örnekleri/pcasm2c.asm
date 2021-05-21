; pcasm2b.asm: Girilen üst limite kadar olan asal sayýlarý dökümleme örneði.
;
; nasm -fwin32 pcasm2c.asm
; gcc  pcasm2c.obj pcasm.c asm_io.obj -o pcasm2c.exe
;----------------------------------------------------------------------------------------------------------
;
; Taþýma/carry ve ödünç/borrow flag/bayrak bitleri kullanýlarak double/duble add/sub toplama/çýkarma
; iþlemlerinde çoklu duble hesaplarý yapýlabilir.
; EDX:EAX + EBX:ECX ==>add eax, ecx (düþük 32-bit, ve) adc edx, ebx (yüksek 32-bit)
; EDX:EAX - EBX:ECX ==>sub eax, ecx (düþük 32, ve) sbb edx, ebx (yüksek 32)
; Çok büyük sayýlarýn toplamý/çýkarmasý döngüyle yapýlabilir, her döngü baþýnda CLC/CLearCarry yapýlýr.
;
; cmp iþlemci1, iþlemci2
; Karþýlaþtýrma iþaretsiz tamsayýda sýfýrsa ZF=1, deðilse + ise CF=0, - ise CF=1 ödünç
; Ýþaretli karþýlaþtýrma ZF/ZeroFlag, SF/SignFlag ve OF/OverflowFlag kullanýr, negatifte SF=1
;
; Þartsýz dallanma JMP/Jump ile tanýmlý paragraf etiketine(:) atlar.
; jmp SHORT-128/NEAR-segment/FAR-segmentdýþý etiket
;
; Þartlý dallanmalar JZ/JumpZero (ZT=1), JNZ/JumpNotZero (ZF=0), JO/JumpOverflow (OF=1),
; JNO/JumpNotOverflow (OF=0), JS/JumpSign (SF=1 pozitif), JNS/JumpNotSign (SF=0),
; JC/JumpCarry (CF=1), JNC/JumpNotCarry (CF=0), JP/JumpParity (PF=1 odd), JNP/JumpNotParity (PF=0 even)
;
; if (EAX == 0) EBX = 1; else EBX = 2; // C kodlama
; cmp eax, 0 ; jz etiket1 ; mov ebx, 2 ; jmp etiket2 (iþaretsiz)
; etiket1: mov ebx, 1
; etiket2:
;
; if (EAX >= 5) EBX = 1; else EBX = 2; // C kodlama
; cmp eax, 5 (iþaretli)
; js iþaretVar ; SF = 1
; jo deðil ; OF = 1 ve SF = 0
; jmp ohalde ; SF = 0 ve OF = 0
; iþaretVar:
; jo ohalde ; SF = 1 ve OF = 1
; deðil:
; mov ebx, 2
; jmp sonra
; ohalde:
; mov ebx, 1
; sonra:
;
; JE/JumpEqual, JNE/JumpNotEqual (iþaretsiz ve iþaretli)
; JL/JumpLess=JNGE/JumpNotGreaterEqual, JLE=JNG, JG=JNLE, JGE=JNL (iþaretli)
; JB/JumpBelow=JNAE/JumpNotAboveEqual, JBE=JNA, JA=JNBE, JAE=JNB (iþaretsiz)
;
; cmp eax, 5
; jge ohalde (iþaretli)
; mov ebx, 2
; jmp ilerle
; ohalde:
; mov ebx, 1
; ilerle:
;
; Döngüler azalan ECX sýfýrlanmasýna bakar: LOOP, LOOPE, LOOPZ, LOOPNE, LOOPNZ
; toplam = 0; // C kodlama
; for (i=10; i > 0; i--) toplam += i;
; mov eax, 0 ; eax=toplam (ASM kodlama)
; mov ecx, 10 ; ecx=i
; döngü:
; add eax, ecx
; loop döngü ; ecx -= 1
;---------------------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"	; extern'lerin tanýmlandýðý dosya

	segment .data
    ÝlkMesaj db "Asallarý bulunacak 5 üstü limiti girin: ", 0
    Parantez db ") ", 0

	segment .bss
    ÜstLimit resd 1		; Bu üst limite kalan olan asallar bulunacak
    AltAsal resd 1		; Asallýðý araþtýrýlacak aktüel tahmin

	segment .text
    global  _esas_kodlama
_esas_kodlama:
    enter 0,0		; Baþlangýç kurulum rutini
    pusha			; EAX dönüþ adresini yýðýna koy

    mov ecx, 0		; ECX döküm sýralama sayacýný sýfýrla
    mov eax, ÝlkMesaj
    call yaz_dizge		; Verigiriþ mesajýný yansýt
    call oku_tms		; ÜstLimit verigiriþini oku: scanf ("%u", &ustLimit);
    mov [ÜstLimit], eax

    add ecx, 1		; Ýlk üç standart asallarý yazdýr
    mov eax, ecx
    call yaz_tms
    mov eax, Parantez
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hiç		; printf("1) 1\n");
    add ecx, 1
    mov eax, ecx
    call yaz_tms
    mov eax, Parantez
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hiç		; printf("2) 2\n");
    add ecx, 1
    mov eax, ecx
    call yaz_tms
    mov eax, Parantez
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hiç		; printf("3) 3\n");

    mov dword [AltAsal], 5	; AltAsal = 5;
while_döngüsü:		; while (AltAsal <= ÜstLimit)
    mov eax, [AltAsal]
    cmp eax, [ÜstLimit]
    jnbe while_döngüsü_sonu	; jnbe/JumpNotBelowEqual (iþaretsiz sayýlar kýyasý)
    mov ebx, 3		; Ýlk bölünen ebx = 3;
while_bölünen:		; while (bolunen * bolunen < altAsal && altAsal % bolunen != 0)
    mov eax, ebx
    mul eax			; edx:eax = eax * eax
    jo while_bölünen_sonu	; jo/JumpOverflow (altAsal % bolunen != 0)
    cmp eax, [AltAsal]
    jnb while_bölünen_sonu	; jnb/JumpNotBelow: if !(bolunen * bolunen < altAsal)
    mov eax, [AltAsal]
    mov edx, 0
    div ebx			; edx = edx:eax % ebx
    cmp edx, 0
    je while_bölünen_sonu	; je/JumpEqual:if !(altAsal % bolunen != 0)
    add ebx, 2		; bolunen += 2;
    jmp while_bölünen
while_bölünen_sonu:

    je if_sonu		; if !(altAsal % bolunen != 0)
    add ecx, 1
    mov eax, ecx
    call yaz_tms
    mov eax, Parantez
    call yaz_dizge
    mov eax, [AltAsal]
    call yaz_tms
    call yaz_hiç		; printf ("x) %u\n")
if_sonu:
    mov eax, [AltAsal]
    add eax, 2
    mov [AltAsal], eax		; altAsal += 2
    jmp while_döngüsü
while_döngüsü_sonu:

    popa			; Sonlandýrma rutini
    ;;mov eax, 0
    leave
    ret			; Çaðýran C'ye dönüþ