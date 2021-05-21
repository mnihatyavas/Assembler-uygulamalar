; pcasm6a.asm: Çift köklü denklem çözümü örneði.
;
; nasm -fwin32 pcasm6a.asm
; gcc -m32 pcasm6a.obj pcasm6a.c
;---------------------------------------------------------------------------------------------------------------------------------
;
; Ondalýk kesirler 10 üstü negatif artanlardýr: 0.123 = 1 x 10^-1 + 2 x 10^-2 + 3 x 10^-3
; Ýkili kesirler de 2 üstü negatif artanlardýr: 0.101 = 1 x 2^-1 + 0 x 2^-2 + 1 x 2^-3 = 0.625
; Ýkili tamsayý ve küsüratlar: 110.011 = 4 + 2 + 0.25 + 0.125 = 6.375
; Ondalýk küsüratý ikili küsürat çevirme, 2'yle çarpýp artanýný alarak yapýlýr:
; 0.5625 × 2 = 1.125	-->ilk bit=1
; 0.125 × 2 = 0.25	-->ikinci bit=0
; 0.25 × 2 = 0.5	-->üçüncü bit=0
; 0.5 × 2 = 1.0	-->dördüncü bit=1
;
; Bazý çevrimler ikilide sonsuz döngülüdür (onludaki 1/3 gibi):
; 0.85 × 2 = 1.7
; 0.7 × 2 = 1.4
; 0.4 × 2 = 0.8
; 0.8 × 2 = 1.6
; 0.6 × 2 = 1.2
; 0.2 × 2 = 0.4
; 0.4 × 2 = 0.8
; 0.8 × 2 = 1.6
; Böylece 0.85 = 0.11(0110) -->son 4 bit tekrarlýdýr. 23.85 = 10111.11(0110)
;
; Kayan noktalý ikilinin IEEE (Institute of Electrical and Electronic Engineers) temsili:
; C'de tek hassasiyetli deðiþkenler float ile, çift hassasiyetler ise double ile tanýmlanýr. Ayrýca uzatýlýmýþ da kullanýlýr.
;
; Toplama:
; 10.375+6.34375=16.71875 toplama iþlemi, tek hassasiyet 32 bit, çift hassasiyet 64 bit (e+f=üs+küsürat))
; þeklinde deðil, göstermek için sadece 8 kullanýlacak.
; 1.0100110x2^3 + 1.1001011x2^2 (üs kadar sola kaydýr, tamsayýdýr; kalaný da küsürat). Küçük üs büyüðü kadar saða kaydýrýlýr.
; 1.0100110x2^3 + 0.1100110x^3=10.0001100x^3=16.(0.5+0.25)=16.75 (gerçeði 16.71875'ten az bit kullanýldýðýndan farklý).
;
; Çýkarma:
; Üsler enbüðüne çevrilir, alttki negatif terslenip 1 eklenerek birlikte toplanýr.
; 16.75-15.9375=0.8125
; 1.0000110x2^4 - 1.1111111x2^3=1.0000110x2^4 - 0.1111111x2^4=1.0000110x2^4 + 1.0000000x2^4=0.0000110x2^4
; =0.50+0.25=0.75 (yaklaþýk)
;
; Çarpma:
; Üsler toplanýr, birer sola kaydýrýlarak alttakiyle tek tek çarpýlýp altalta sýralanýr, sonuç toplanýr; 8 bitle sýnýrlanýr.
; 10.375 x 2.5=25.9375
; 1.0100110x2^3 X 1.0100000x2^1=1.1001111(1000000)x2^4=25.(0.5+0.25+0.125[+0.0675])=25.875 (yaklaþýk)
;
; Hesap kesinliði olmadýðýndan küsüratlý kýyaslarda hassas eþitlik yerine seçtiðimiz EPS'la kýyaslamak yeðlenmelidir.
; if (f(x) == 0.0) yerine if (fabs (f(x)) < EPS), keza if (fabs (x-y) /fabs (y) < EPS)
;
; Ýþlemcilerde matematik eþ-iþlemciler vardýr (87, 287, 387 gibi). Herbiri 80 bit'li kayan nokta tutan 8 matematik
; kayýtçý (ST0, ST1, ..., ST7) vardýr, normalen yýðýla LIFO çalýþýr. Matematik durum kayýtçýnýn 4 bayraðý C0, .., C3'dür.
; Tüm eþiþlemci komutlarý F/Float ile baþlar.
; FLD kaynak: Hafýzadan aldýðý küsüratlýyý eþiþlemci yýðýn tepesine kaynak olarak (tek, çift, uzatýlmýþ hassasiyetli,
; eþiþlemci kayýtçý) depolar.
; FILD kynk: Hafýzadan aldýðý tamsayýyý küsüratlý olarak depolar.
; FLD1: üst yýðýna 1 depolar.
; FLDZ: sýfýr depolar.
; FST hedef: Üst yýðýndan aldýðýný belleðe depolar.
; FSTP hdf: Önceki gibidir, sonrasýnda yýðýndan siler/Pop.
; FIST hdf: yýðýndan aldýðýný belleðe tamsayý olarak depolar.
; FISTP hdf: Önceki gibidir, sonrasýnda yýðýný siler/Pop.
; FXCH STn: ST0 deðeriyle STn deðerini yerdeðiþtirir.
; FFREE STn: Yýðýndaki kayýtçý n içeriðini boþaltýr.
; Toplama komutlarý:
; FADD kynk: ST0 += kynk
; FADD hdf, ST0: hdf += ST0
; FADDP hdf veya FADDP hdf, ST0: hdf += ST0 ve yýðýndan Pop
; FIADD kynk: ST0 += kynk, tamsayý olarak depolar
;
; Toplama kodlamasý:
; segment .bss
; dizi resq EBAT
; toplam resq 1
; segment .text
; mov ecx, EBAT
; mov esi, dizi
; fldz ; ST0 = 0
; döngü:
; fadd qword [esi] ; ST0 += *(esi)
; add esi, 8 ; bir sonraki double'a endeksle
; loop döngü
; fstp qword toplam ; toplam = ST0
;
; Çýkarma komutlarý:
; FSUB kynk: ST0 -= kynk
; FSUBR kynk: R/Reverse/TersÇýkar, ST0=kynk-ST0
; FSUB hdf, ST0: hdf -= ST0
; FSUBR hdf, ST0: hdf=ST0-hdf
; FSUBP hdf, veya FSUBP hdf, ST0: hdf -= ST0 ve Pop
; FSUBRP hdf, veya FSUBRP hdf, ST0: hdf=ST0-hdf ve Pop
; FISUB kynk: ST0 -= (float) kynk, tamsayý depola
; FISUBR kynk: ST0=(float) kynk-ST0, tamsayý depola
;
; Çarpma komutlarý (toplama gibidir):
; FMUL kynk: ST0 *= kynk
; FMUL hdf, ST0: hdf *= ST0
; FMULP hdf, veya FMULP hdf, ST0: hdf *= ST0 ve Pop
; FIMUL kynk: ST0 *= (float) kynk, tamsayý depola
;
; Bölme komutlarý (çýkarma gibidir):
; FDIV kynk: ST0 /= kynk
; FDIVR kynk: STO=kynk/ST0
; FDIV hdf, ST0: hdf /= ST0
; FDIVR hdf, ST0: hdf=ST0/hdf
; FDIVP hdf, veya FDIVP hdf, ST0: hdf /= ST0 ve Pop
; FDIVRP hdf, veya FDIVRP hdf, ST0: hdf=ST0/hdf ve Pop
; FIDIV kynk: ST0 /= kynk, tamsayý depola
; FIDIVR kynk: ST0=(float)kynk/ST0, tamsayý depola
;
; Kýyaslama komutlarý:
; FCOM kynk: FloatCompare, kynk kýyas ST0
; FCOMP kynk: kynk kýyas ST0 ve Pop
; FCOMPP: ST0 kýyas ST1 ve Pop duble
; FICOM kynk: ST0 kýyas kynk, kynk tamsayý
; FICOMP kynk: ST0 kýyas kynk, kynk tamsayý, ve Pop
; FTST: ST0 kýyas 0
; FCOMI kynk: ST0 kýyas kynk/eþiþlemci kayýtçýsý
; FCOMIP kynk: ST0 kýyas kynk/eþiþlemci kayýtçýsý ve Pop
;
;; Kýyaslama kodlama örneði:
;; if ( x > y )
; fld qword [x] ; ST0 = x
; fcomp qword [y] ; STO kýyas y
; fstsw ax ; eþiþlemci statü kelimesini AX'e yükle
; sahf ; AH'yý Flag kayýtçýya yükle ; LAHF: AH'ya Flag'leri yükle
; jna deðilse ; JumpNotAbove
; ohalde:
;; ohalde kodlamalarý
; jmp eðer_sonu
; deðilse:
;; deðilse kodlamalarý
; eðer_sonu:
;
; Birkaç komut daha:
; FCHS: ST0 = -ST0, ChangeSign
; FABS: ST0 = |ST0|, Absolute
; FSQRT: ST0 = (ST0)^0.5, Squareroot
; FSCALE: ST0 = ST0*2^[ST1]
;
; FSCALE örneði:
; segment .data
;; x dq 2.75 ; dubleye çevrilecek
; beþ dw 5
; segment .text
; fild dword [beþ] ; ST0 = 5 (tamsayýdan)
; fld qword [x] ; ST0 = 2.75, ST1 = 5
; fscale ; ST0 = 2.75 * 32, ST1 = 5 (32=2^5)
;---------------------------------------------------------------------------------------------------------------------------------

; Ýki bilinmeyenli fonksiyon
; Aþaðýdaki denklemin çözümü bulunacak
;   a*x^2 + b*x + c = 0
; x1,2=(-b+-(b^2-4ac)^0.5) / 2a
; C ilkörneði:
;   int çiftkök (double a, double b, double c, double * kök1, double *kök2 )
; Parametreler:
;   a, b, c - çiftköklü denklemin katsayýlarý
;   kök1   - bulunacak ilk duble kökün depo iþaretçisi
;   kök2   - bulunacak ikinci duble kökün depo iþaretçisi
; Dönen deðer:
;   gerçek kökler bulunursa 1, deðilse 0 döndürür

    %define a qword [ebp+8]
    %define b qword [ebp+16]
    %define c qword [ebp+24]
    %define kök1 dword [ebp+32]
    %define kök2 dword [ebp+36]
    %define kriter qword [ebp-8]
    %define bir_bölü_2a qword [ebp-16]

	segment .data
    EksiDört dw -4

	segment .bss
	segment .text
    global  _ciftkok
_ciftkok:
    push ebp
    mov ebp, esp
    sub esp, 16	; 2 duble (kriter & bir_bölü_2a) için yer tahsisi
    push ebx	; ilk ebx muhafaza

    fild word [EksiDört]	; Tamsayý -4 eþiþlemci matematik yýðýna
    fld a			; a katsayýsý yýðýna
    fld c			; c katsayýsý yýðýna
    fmulp st1		; ST1 = a * c
    fmulp st1		; ST1 = a * c * -4
    fld b			; b katsayýsý yýðýna
    fld b			; tekrar b katsayýsý öteki yýðýna
    fmulp st1		; ST1 = b * b
    faddp st1		; ST1 =  b*b - 4*a*c ve Pop/çýkar
    ftst			; ST1 kýyas 0
    fstsw ax		; Statüleri (c0,c1,c2,c3) AX'e yükle
    sahf			; AH'ý Flag'e yükle
    jb gerçek_çözüm_yok	; eðer kriter < 0, gerçek kök yok
    fsqrt			; ST1 = karekök (b*b - 4*a*c)
    fstp kriter		; Depola ve yýðýndan sil
    fld1			; yýðýn: 1.0
    fld a			; yýðýn: a, 1.0
    fscale			; yýðýn: a * 2^(1.0) = 2*a, 1
    fdivp st1		; yýðýn: 1 / (2 * a)
    fst bir_bölü_2a		; yýðýn: 1 / (2 * a)
    fld b			; yýðýn: b, 1/(2*a)
    fld kriter		; yýðýn: kriter, b, 1/(2*a)
    fsubrp st1		; ST1: kriter - b, 1/(2*a)
    fmulp st1		; ST1: (-b + kriter) / (2*a)
    mov ebx, kök1
    fstp qword [ebx]		; *kök1 adresine deðeri ata
    fld b			; Tekrar yýðýn: b
    fld kriter		; yýðýn: kriter, b
    fchs			; yýðýn (iþaret deðiþtir): -kriter, b
    fsubrp st1		; yýðýn: -kriter - b
    fmul bir_bölü_2a		; yýðýn: (-b - kriter) / (2*a)
    mov ebx, kök2
    fstp qword [ebx]		; *kök2 adresine deðeri ata
    mov eax, 1		; 1 döndür (gerçek kökler var)
    jmp short çýkýþ

gerçek_çözüm_yok:
    ffree st0		; yýðýndan kriter'i çýkar
    mov eax, 0		; 0 döndür (gerçek kök yok)

çýkýþ:
    pop ebx
    mov esp, ebp
    pop ebp
    ret