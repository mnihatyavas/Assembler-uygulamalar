; pcasm6a.asm: �ift k�kl� denklem ��z�m� �rne�i.
;
; nasm -fwin32 pcasm6a.asm
; gcc -m32 pcasm6a.obj pcasm6a.c
;---------------------------------------------------------------------------------------------------------------------------------
;
; Ondal�k kesirler 10 �st� negatif artanlard�r: 0.123 = 1 x 10^-1 + 2 x 10^-2 + 3 x 10^-3
; �kili kesirler de 2 �st� negatif artanlard�r: 0.101 = 1 x 2^-1 + 0 x 2^-2 + 1 x 2^-3 = 0.625
; �kili tamsay� ve k�s�ratlar: 110.011 = 4 + 2 + 0.25 + 0.125 = 6.375
; Ondal�k k�s�rat� ikili k�s�rat �evirme, 2'yle �arp�p artan�n� alarak yap�l�r:
; 0.5625 � 2 = 1.125	-->ilk bit=1
; 0.125 � 2 = 0.25	-->ikinci bit=0
; 0.25 � 2 = 0.5	-->���nc� bit=0
; 0.5 � 2 = 1.0	-->d�rd�nc� bit=1
;
; Baz� �evrimler ikilide sonsuz d�ng�l�d�r (onludaki 1/3 gibi):
; 0.85 � 2 = 1.7
; 0.7 � 2 = 1.4
; 0.4 � 2 = 0.8
; 0.8 � 2 = 1.6
; 0.6 � 2 = 1.2
; 0.2 � 2 = 0.4
; 0.4 � 2 = 0.8
; 0.8 � 2 = 1.6
; B�ylece 0.85 = 0.11(0110) -->son 4 bit tekrarl�d�r. 23.85 = 10111.11(0110)
;
; Kayan noktal� ikilinin IEEE (Institute of Electrical and Electronic Engineers) temsili:
; C'de tek hassasiyetli de�i�kenler float ile, �ift hassasiyetler ise double ile tan�mlan�r. Ayr�ca uzat�l�m�� da kullan�l�r.
;
; Toplama:
; 10.375+6.34375=16.71875 toplama i�lemi, tek hassasiyet 32 bit, �ift hassasiyet 64 bit (e+f=�s+k�s�rat))
; �eklinde de�il, g�stermek i�in sadece 8 kullan�lacak.
; 1.0100110x2^3 + 1.1001011x2^2 (�s kadar sola kayd�r, tamsay�d�r; kalan� da k�s�rat). K���k �s b�y��� kadar sa�a kayd�r�l�r.
; 1.0100110x2^3 + 0.1100110x^3=10.0001100x^3=16.(0.5+0.25)=16.75 (ger�e�i 16.71875'ten az bit kullan�ld���ndan farkl�).
;
; ��karma:
; �sler enb���ne �evrilir, alttki negatif terslenip 1 eklenerek birlikte toplan�r.
; 16.75-15.9375=0.8125
; 1.0000110x2^4 - 1.1111111x2^3=1.0000110x2^4 - 0.1111111x2^4=1.0000110x2^4 + 1.0000000x2^4=0.0000110x2^4
; =0.50+0.25=0.75 (yakla��k)
;
; �arpma:
; �sler toplan�r, birer sola kayd�r�larak alttakiyle tek tek �arp�l�p altalta s�ralan�r, sonu� toplan�r; 8 bitle s�n�rlan�r.
; 10.375 x 2.5=25.9375
; 1.0100110x2^3 X 1.0100000x2^1=1.1001111(1000000)x2^4=25.(0.5+0.25+0.125[+0.0675])=25.875 (yakla��k)
;
; Hesap kesinli�i olmad���ndan k�s�ratl� k�yaslarda hassas e�itlik yerine se�ti�imiz EPS'la k�yaslamak ye�lenmelidir.
; if (f(x) == 0.0) yerine if (fabs (f(x)) < EPS), keza if (fabs (x-y) /fabs (y) < EPS)
;
; ��lemcilerde matematik e�-i�lemciler vard�r (87, 287, 387 gibi). Herbiri 80 bit'li kayan nokta tutan 8 matematik
; kay�t�� (ST0, ST1, ..., ST7) vard�r, normalen y���la LIFO �al���r. Matematik durum kay�t��n�n 4 bayra�� C0, .., C3'd�r.
; T�m e�i�lemci komutlar� F/Float ile ba�lar.
; FLD kaynak: Haf�zadan ald��� k�s�ratl�y� e�i�lemci y���n tepesine kaynak olarak (tek, �ift, uzat�lm�� hassasiyetli,
; e�i�lemci kay�t��) depolar.
; FILD kynk: Haf�zadan ald��� tamsay�y� k�s�ratl� olarak depolar.
; FLD1: �st y���na 1 depolar.
; FLDZ: s�f�r depolar.
; FST hedef: �st y���ndan ald���n� belle�e depolar.
; FSTP hdf: �nceki gibidir, sonras�nda y���ndan siler/Pop.
; FIST hdf: y���ndan ald���n� belle�e tamsay� olarak depolar.
; FISTP hdf: �nceki gibidir, sonras�nda y���n� siler/Pop.
; FXCH STn: ST0 de�eriyle STn de�erini yerde�i�tirir.
; FFREE STn: Y���ndaki kay�t�� n i�eri�ini bo�alt�r.
; Toplama komutlar�:
; FADD kynk: ST0 += kynk
; FADD hdf, ST0: hdf += ST0
; FADDP hdf veya FADDP hdf, ST0: hdf += ST0 ve y���ndan Pop
; FIADD kynk: ST0 += kynk, tamsay� olarak depolar
;
; Toplama kodlamas�:
; segment .bss
; dizi resq EBAT
; toplam resq 1
; segment .text
; mov ecx, EBAT
; mov esi, dizi
; fldz ; ST0 = 0
; d�ng�:
; fadd qword [esi] ; ST0 += *(esi)
; add esi, 8 ; bir sonraki double'a endeksle
; loop d�ng�
; fstp qword toplam ; toplam = ST0
;
; ��karma komutlar�:
; FSUB kynk: ST0 -= kynk
; FSUBR kynk: R/Reverse/Ters��kar, ST0=kynk-ST0
; FSUB hdf, ST0: hdf -= ST0
; FSUBR hdf, ST0: hdf=ST0-hdf
; FSUBP hdf, veya FSUBP hdf, ST0: hdf -= ST0 ve Pop
; FSUBRP hdf, veya FSUBRP hdf, ST0: hdf=ST0-hdf ve Pop
; FISUB kynk: ST0 -= (float) kynk, tamsay� depola
; FISUBR kynk: ST0=(float) kynk-ST0, tamsay� depola
;
; �arpma komutlar� (toplama gibidir):
; FMUL kynk: ST0 *= kynk
; FMUL hdf, ST0: hdf *= ST0
; FMULP hdf, veya FMULP hdf, ST0: hdf *= ST0 ve Pop
; FIMUL kynk: ST0 *= (float) kynk, tamsay� depola
;
; B�lme komutlar� (��karma gibidir):
; FDIV kynk: ST0 /= kynk
; FDIVR kynk: STO=kynk/ST0
; FDIV hdf, ST0: hdf /= ST0
; FDIVR hdf, ST0: hdf=ST0/hdf
; FDIVP hdf, veya FDIVP hdf, ST0: hdf /= ST0 ve Pop
; FDIVRP hdf, veya FDIVRP hdf, ST0: hdf=ST0/hdf ve Pop
; FIDIV kynk: ST0 /= kynk, tamsay� depola
; FIDIVR kynk: ST0=(float)kynk/ST0, tamsay� depola
;
; K�yaslama komutlar�:
; FCOM kynk: FloatCompare, kynk k�yas ST0
; FCOMP kynk: kynk k�yas ST0 ve Pop
; FCOMPP: ST0 k�yas ST1 ve Pop duble
; FICOM kynk: ST0 k�yas kynk, kynk tamsay�
; FICOMP kynk: ST0 k�yas kynk, kynk tamsay�, ve Pop
; FTST: ST0 k�yas 0
; FCOMI kynk: ST0 k�yas kynk/e�i�lemci kay�t��s�
; FCOMIP kynk: ST0 k�yas kynk/e�i�lemci kay�t��s� ve Pop
;
;; K�yaslama kodlama �rne�i:
;; if ( x > y )
; fld qword [x] ; ST0 = x
; fcomp qword [y] ; STO k�yas y
; fstsw ax ; e�i�lemci stat� kelimesini AX'e y�kle
; sahf ; AH'y� Flag kay�t��ya y�kle ; LAHF: AH'ya Flag'leri y�kle
; jna de�ilse ; JumpNotAbove
; ohalde:
;; ohalde kodlamalar�
; jmp e�er_sonu
; de�ilse:
;; de�ilse kodlamalar�
; e�er_sonu:
;
; Birka� komut daha:
; FCHS: ST0 = -ST0, ChangeSign
; FABS: ST0 = |ST0|, Absolute
; FSQRT: ST0 = (ST0)^0.5, Squareroot
; FSCALE: ST0 = ST0*2^[ST1]
;
; FSCALE �rne�i:
; segment .data
;; x dq 2.75 ; dubleye �evrilecek
; be� dw 5
; segment .text
; fild dword [be�] ; ST0 = 5 (tamsay�dan)
; fld qword [x] ; ST0 = 2.75, ST1 = 5
; fscale ; ST0 = 2.75 * 32, ST1 = 5 (32=2^5)
;---------------------------------------------------------------------------------------------------------------------------------

; �ki bilinmeyenli fonksiyon
; A�a��daki denklemin ��z�m� bulunacak
;   a*x^2 + b*x + c = 0
; x1,2=(-b+-(b^2-4ac)^0.5) / 2a
; C ilk�rne�i:
;   int �iftk�k (double a, double b, double c, double * k�k1, double *k�k2 )
; Parametreler:
;   a, b, c - �iftk�kl� denklemin katsay�lar�
;   k�k1   - bulunacak ilk duble k�k�n depo i�aret�isi
;   k�k2   - bulunacak ikinci duble k�k�n depo i�aret�isi
; D�nen de�er:
;   ger�ek k�kler bulunursa 1, de�ilse 0 d�nd�r�r

    %define a qword [ebp+8]
    %define b qword [ebp+16]
    %define c qword [ebp+24]
    %define k�k1 dword [ebp+32]
    %define k�k2 dword [ebp+36]
    %define kriter qword [ebp-8]
    %define bir_b�l�_2a qword [ebp-16]

	segment .data
    EksiD�rt dw -4

	segment .bss
	segment .text
    global  _ciftkok
_ciftkok:
    push ebp
    mov ebp, esp
    sub esp, 16	; 2 duble (kriter & bir_b�l�_2a) i�in yer tahsisi
    push ebx	; ilk ebx muhafaza

    fild word [EksiD�rt]	; Tamsay� -4 e�i�lemci matematik y���na
    fld a			; a katsay�s� y���na
    fld c			; c katsay�s� y���na
    fmulp st1		; ST1 = a * c
    fmulp st1		; ST1 = a * c * -4
    fld b			; b katsay�s� y���na
    fld b			; tekrar b katsay�s� �teki y���na
    fmulp st1		; ST1 = b * b
    faddp st1		; ST1 =  b*b - 4*a*c ve Pop/��kar
    ftst			; ST1 k�yas 0
    fstsw ax		; Stat�leri (c0,c1,c2,c3) AX'e y�kle
    sahf			; AH'� Flag'e y�kle
    jb ger�ek_��z�m_yok	; e�er kriter < 0, ger�ek k�k yok
    fsqrt			; ST1 = karek�k (b*b - 4*a*c)
    fstp kriter		; Depola ve y���ndan sil
    fld1			; y���n: 1.0
    fld a			; y���n: a, 1.0
    fscale			; y���n: a * 2^(1.0) = 2*a, 1
    fdivp st1		; y���n: 1 / (2 * a)
    fst bir_b�l�_2a		; y���n: 1 / (2 * a)
    fld b			; y���n: b, 1/(2*a)
    fld kriter		; y���n: kriter, b, 1/(2*a)
    fsubrp st1		; ST1: kriter - b, 1/(2*a)
    fmulp st1		; ST1: (-b + kriter) / (2*a)
    mov ebx, k�k1
    fstp qword [ebx]		; *k�k1 adresine de�eri ata
    fld b			; Tekrar y���n: b
    fld kriter		; y���n: kriter, b
    fchs			; y���n (i�aret de�i�tir): -kriter, b
    fsubrp st1		; y���n: -kriter - b
    fmul bir_b�l�_2a		; y���n: (-b - kriter) / (2*a)
    mov ebx, k�k2
    fstp qword [ebx]		; *k�k2 adresine de�eri ata
    mov eax, 1		; 1 d�nd�r (ger�ek k�kler var)
    jmp short ��k��

ger�ek_��z�m_yok:
    ffree st0		; y���ndan kriter'i ��kar
    mov eax, 0		; 0 d�nd�r (ger�ek k�k yok)

��k��:
    pop ebx
    mov esp, ebp
    pop ebp
    ret