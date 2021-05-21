; pcasm2b.asm: Girilen �st limite kadar olan asal say�lar� d�k�mleme �rne�i.
;
; nasm -fwin32 pcasm2c.asm
; gcc  pcasm2c.obj pcasm.c asm_io.obj -o pcasm2c.exe
;----------------------------------------------------------------------------------------------------------
;
; Ta��ma/carry ve �d�n�/borrow flag/bayrak bitleri kullan�larak double/duble add/sub toplama/��karma
; i�lemlerinde �oklu duble hesaplar� yap�labilir.
; EDX:EAX + EBX:ECX ==>add eax, ecx (d���k 32-bit, ve) adc edx, ebx (y�ksek 32-bit)
; EDX:EAX - EBX:ECX ==>sub eax, ecx (d���k 32, ve) sbb edx, ebx (y�ksek 32)
; �ok b�y�k say�lar�n toplam�/��karmas� d�ng�yle yap�labilir, her d�ng� ba��nda CLC/CLearCarry yap�l�r.
;
; cmp i�lemci1, i�lemci2
; Kar��la�t�rma i�aretsiz tamsay�da s�f�rsa ZF=1, de�ilse + ise CF=0, - ise CF=1 �d�n�
; ��aretli kar��la�t�rma ZF/ZeroFlag, SF/SignFlag ve OF/OverflowFlag kullan�r, negatifte SF=1
;
; �arts�z dallanma JMP/Jump ile tan�ml� paragraf etiketine(:) atlar.
; jmp SHORT-128/NEAR-segment/FAR-segmentd��� etiket
;
; �artl� dallanmalar JZ/JumpZero (ZT=1), JNZ/JumpNotZero (ZF=0), JO/JumpOverflow (OF=1),
; JNO/JumpNotOverflow (OF=0), JS/JumpSign (SF=1 pozitif), JNS/JumpNotSign (SF=0),
; JC/JumpCarry (CF=1), JNC/JumpNotCarry (CF=0), JP/JumpParity (PF=1 odd), JNP/JumpNotParity (PF=0 even)
;
; if (EAX == 0) EBX = 1; else EBX = 2; // C kodlama
; cmp eax, 0 ; jz etiket1 ; mov ebx, 2 ; jmp etiket2 (i�aretsiz)
; etiket1: mov ebx, 1
; etiket2:
;
; if (EAX >= 5) EBX = 1; else EBX = 2; // C kodlama
; cmp eax, 5 (i�aretli)
; js i�aretVar ; SF = 1
; jo de�il ; OF = 1 ve SF = 0
; jmp ohalde ; SF = 0 ve OF = 0
; i�aretVar:
; jo ohalde ; SF = 1 ve OF = 1
; de�il:
; mov ebx, 2
; jmp sonra
; ohalde:
; mov ebx, 1
; sonra:
;
; JE/JumpEqual, JNE/JumpNotEqual (i�aretsiz ve i�aretli)
; JL/JumpLess=JNGE/JumpNotGreaterEqual, JLE=JNG, JG=JNLE, JGE=JNL (i�aretli)
; JB/JumpBelow=JNAE/JumpNotAboveEqual, JBE=JNA, JA=JNBE, JAE=JNB (i�aretsiz)
;
; cmp eax, 5
; jge ohalde (i�aretli)
; mov ebx, 2
; jmp ilerle
; ohalde:
; mov ebx, 1
; ilerle:
;
; D�ng�ler azalan ECX s�f�rlanmas�na bakar: LOOP, LOOPE, LOOPZ, LOOPNE, LOOPNZ
; toplam = 0; // C kodlama
; for (i=10; i > 0; i--) toplam += i;
; mov eax, 0 ; eax=toplam (ASM kodlama)
; mov ecx, 10 ; ecx=i
; d�ng�:
; add eax, ecx
; loop d�ng� ; ecx -= 1
;---------------------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"	; extern'lerin tan�mland��� dosya

	segment .data
    �lkMesaj db "Asallar� bulunacak 5 �st� limiti girin: ", 0
    Parantez db ") ", 0

	segment .bss
    �stLimit resd 1		; Bu �st limite kalan olan asallar bulunacak
    AltAsal resd 1		; Asall��� ara�t�r�lacak akt�el tahmin

	segment .text
    global  _esas_kodlama
_esas_kodlama:
    enter 0,0		; Ba�lang�� kurulum rutini
    pusha			; EAX d�n�� adresini y���na koy

    mov ecx, 0		; ECX d�k�m s�ralama sayac�n� s�f�rla
    mov eax, �lkMesaj
    call yaz_dizge		; Verigiri� mesaj�n� yans�t
    call oku_tms		; �stLimit verigiri�ini oku: scanf ("%u", &ustLimit);
    mov [�stLimit], eax

    add ecx, 1		; �lk �� standart asallar� yazd�r
    mov eax, ecx
    call yaz_tms
    mov eax, Parantez
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hi�		; printf("1) 1\n");
    add ecx, 1
    mov eax, ecx
    call yaz_tms
    mov eax, Parantez
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hi�		; printf("2) 2\n");
    add ecx, 1
    mov eax, ecx
    call yaz_tms
    mov eax, Parantez
    call yaz_dizge
    mov eax, ecx
    call yaz_tms
    call yaz_hi�		; printf("3) 3\n");

    mov dword [AltAsal], 5	; AltAsal = 5;
while_d�ng�s�:		; while (AltAsal <= �stLimit)
    mov eax, [AltAsal]
    cmp eax, [�stLimit]
    jnbe while_d�ng�s�_sonu	; jnbe/JumpNotBelowEqual (i�aretsiz say�lar k�yas�)
    mov ebx, 3		; �lk b�l�nen ebx = 3;
while_b�l�nen:		; while (bolunen * bolunen < altAsal && altAsal % bolunen != 0)
    mov eax, ebx
    mul eax			; edx:eax = eax * eax
    jo while_b�l�nen_sonu	; jo/JumpOverflow (altAsal % bolunen != 0)
    cmp eax, [AltAsal]
    jnb while_b�l�nen_sonu	; jnb/JumpNotBelow: if !(bolunen * bolunen < altAsal)
    mov eax, [AltAsal]
    mov edx, 0
    div ebx			; edx = edx:eax % ebx
    cmp edx, 0
    je while_b�l�nen_sonu	; je/JumpEqual:if !(altAsal % bolunen != 0)
    add ebx, 2		; bolunen += 2;
    jmp while_b�l�nen
while_b�l�nen_sonu:

    je if_sonu		; if !(altAsal % bolunen != 0)
    add ecx, 1
    mov eax, ecx
    call yaz_tms
    mov eax, Parantez
    call yaz_dizge
    mov eax, [AltAsal]
    call yaz_tms
    call yaz_hi�		; printf ("x) %u\n")
if_sonu:
    mov eax, [AltAsal]
    add eax, 2
    mov [AltAsal], eax		; altAsal += 2
    jmp while_d�ng�s�
while_d�ng�s�_sonu:

    popa			; Sonland�rma rutini
    ;;mov eax, 0
    leave
    ret			; �a��ran C'ye d�n��