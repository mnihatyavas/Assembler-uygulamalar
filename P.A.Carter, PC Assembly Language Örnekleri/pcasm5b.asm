; pcasm5b.asm: Girilen karakteri c�mlede arama ve dizge uzunlu�unu hesaplama �rne�i.
;
; nasm -fwin32 pcasm5b.asm
; gcc -m32 pcasm5b.obj pcasm5b.c
;---------------------------------------------------------------------------------------------------------------------------------

; �ok boyutlu diziler, bellekte ger�ekte tek boyutlu diziler gibi adreslenirler.
; int a[3][2] dizisinin bellekte endeks/eleman sat�rvari dizilimi: 0/a[0][0], 1/a[0][1], 2/a[1][0], 3/a[1][1], 4/a[2][0], 5/[2][1]
; Endeks hesaplamay� 2*i+j (her sat�rda 2 elemen) form�lle yapar.
;
;; mov eax, [ebp - 44]	; i'nin konumu = ebp - 44
;; sal eax, 1		; Shift-left ile i*2
;; add eax, [ebp - 48]		; j'nin konumu=ebp-46; i*2 + j
;; mov eax, [ebp + 4*eax - 40]	; a[0][0]'�n adres i= ebp - 40
;; mov [ebp - 52], eax	; x=2*i+j sonucunu [ebp - 52]'ye ta��
;
; �ki boyutlu N kolonlu form�l = N*i+j
; 
; �� boyutlu int b[4][3][2]=b[L][M][N] ise endeks formul� = M*N*i + N*j + k; ilk L g�z�n�ne al�nmaz
; void f(int *a[]); void f(int a[][2]); void f(int a[][4][3][2]; ge�erli bellek tahsisleridir.
;
; Dizgeler dizi gibi artan/azalan i�lem g�r�r, y�n� DF/DirectionFlag belirler, ESI yada EDI endeks kay�t��larla takip edilir.
; CLD/ClearDF artand�r; STD/SetDF azaland�r.
;
; Dizgelerin Byte, Word, DoubleWord olarak okunma/LOD ve yazma/STO komutlar�:
;; LODSB AL = [DS:ESI]	; ESI = ESI � 1
;; STOSB [ES:EDI] = AL	; EDI = EDI � 1
;; LODSW AX = [DS:ESI]	; ESI = ESI � 2
;; STOSW [ES:EDI] = AX	; EDI = EDI � 2
;; LODSD EAX = [DS:ESI]	; ESI = ESI � 4
;; STOSD [ES:EDI] = EAX	; EDI = EDI � 4
;
; dizi1'i oku ve dizi2'ye yaz
;; segment .data
;; dizi1 dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
;; segment .bss
;; dizi2 resd 10
;; segment .text
;; cld	; artan
;; mov esi, dizi1	; SI/SourceIndex
;; mov edi, dizi2	; DI/DestinationIndex
;; mov ecx, 10
;; d�ng�:
;; lodsd	; LoadStringDouble, oku
;; stosd	; StoreStringDouble, yaz
;; loop d�ng�
;
; Haf�zadaki dizgenin Byte, Word, DoubleWord ta��nmas�:
;; MOVSB byte [ES:EDI] = byte [DS:ESI]		; ESI = ESI � 1	; EDI = EDI � 1
;; MOVSW word [ES:EDI] = word [DS:ESI]	; ESI = ESI � 2	; EDI = EDI � 2
;; MOVSD dword [ES:EDI] = dword [DS:ESI]	; ESI = ESI � 4	; EDI = EDI � 4
;
; 10 elemanl� s�f�r dizisi
;; segment .bss
;; dizi resd 10
;; segment .text
;; cld	; artan
;; mov edi, dizi
;; mov ecx, 10
;; xor eax, eax	; eax=0
;; rep stosd	; REPeat ECX kere; dizi=eax=0
;
; Dizgelerde CMP i�in CMPSx, x=Byte/Word/Doubleword k�yaslar
; SCASx ise SCAN tarar, ara�t�r�r
;; CMPSB kar��la�t�r byte [DS:ESI] ve byte [ES:EDI]		; ESI = ESI � 1	; EDI = EDI � 1
;; CMPSW kar��la�t�r word [DS:ESI] ve word [ES:EDI]	; ESI = ESI � 2	; EDI = EDI � 2
;; CMPSD kar��la�t�r dword [DS:ESI] ve dword [ES:EDI]	; ESI = ESI � 4	; EDI = EDI � 4
;; SCASB tara AL ve [ES:EDI]		; EDI � 1
;; SCASW tara AX and [ES:EDI]	; EDI � 2
;; SCASD tara EAX and [ES:EDI]	; EDI � 4
;
; 100 elemanl� dizide 12 de�erli eleman� arama �rne�i:
;; segment .bss
;; dizi resd 100
;; segment .text
;; cld
;; mov edi, dizi	; Diziyi bellekte ba�latma g�stergeci
;; mov ecx, 100	; Dizi eleman say�s�
;; mov eax, 12	; Aranan de�er
;; d�ng�:
;; scasd
;; je bulundu
;; loop d�ng�
;;; Bulunamazsa buraya gelir
;; jmp ilerle
;; bulundu:
;; sub edi, 4	; edi �imdi 12 de�erini i�eren dizi eleman�n� i�aret eder
;;; Programa devam
;; ilerle:
;
; �artl� tekrar� k�rma: REPZ/RepeatZero, REPE/RepeatEqual, REPNZ/RepeatNotZero, REPNE/RepeatNotEqual
;
; �ki bellek blo�unun e�itli�i kar��la�t�rmas� �rne�i:
;; segment .text
;; cld
;; mov esi, blok1	; �lk blok ba�lang�� adresi
;; mov edi, blok2	; �kinci blok ba�lang�� adresi
;; mov ecx, EBAT	; Bloklar�n Byte ebat�
;; repe cmpsb	; ZF=1'e dek takrarlar
;; je e�it		; E�er ZF=1 ise
;;; Bloklar e�it de�ilse k�r
;; jmp ilerle
;; e�it:
;;; E�itse buradad�r
;; ilerle:
;---------------------------------------------------------------------------------------------------------------------------------

    global _asm_kopyala, _asm_bul, _asm_uzunluk, _asm_dzgkopya

	segment .text
; _asm_kopyala fonksiyonu:
; Test dizgesini di�er bir dizgeye kopyalar
; C prototipi:
; void asm_kopyala (void * hedef, const void * kaynak, unsigned ebat);
; parametreler:
;   hedef - kopyalanacak bellek tamoununu i�aretler
;   kaynak - kopyalanan bellek tamponunu i�aretler
;   ebat - kopyalanacak byte say�s�

; Bellek adreslerini adlarla tan�mlayal�m

    %define hedef [ebp+8]
    %define kaynak  [ebp+12]
    %define ebat   [ebp+16]
_asm_kopyala:
    enter 0, 0
    push esi
    push edi

    mov esi, kaynak	; esi = kopyalanacak tampon adresi
    mov edi, hedef	; edi = kopyalanan tampon adresi
    mov ecx, ebat	; ecx = kopyalanacak byte say�s�

    cld		; ClearDirection-flag, artan
    rep movsb	; movsb/MoveStringByte esi-->edi ta��ma komutunu ECX kere tekrarla

    pop edi
    pop esi
    leave
    ret

; _asm_bul fonksiyonu:
; Bellekteki test dizgesini girilen krk i�in ara�t�r�r
; void * asm_bul (const void * kaynak, char hedef, unsigned ebat);
; parametreler:
;   kaynak - ara�t�r�lacak tamponu i�aretler
;   dedef - ara�t�r�lan de�eri i�aretler
;   ebat - tampondaki byte say�s�
; d�nen de�er:
;   e�er hedef bulunduysa, tampondaki ilk bulunan konumun i�aret�isi d�ner
;   de�ilse
;     NULL/hi� d�ner
; NOT: hedef byte olsa da, y���na dword de�er olarak konur
;       Byte de�eri alt 8-bit'e depolan�r

    %define kaynak [ebp+8]
    %define hedef [ebp+12]
    %define ebat [ebp+16]

_asm_bul:
    enter 0, 0
    push edi

    mov eax, hedef	; al ara�t�r�lacak krk'i i�erir
    mov edi, kaynak
    mov ecx, ebat
    cld		; artan

    repne scasb	; scansb/ScanStringByte ara�t�r ta ki ECX == 0 veya [ES:EDI] == AL

    je buldum	; ZF=1 ise bulunmu�tur
    mov eax, 0	; bulunmad�ysa EAX=0/NULL d�nd�r
    jmp short ��k
buldum:
    mov eax, edi
    dec eax		; bulunduysa (DI - 1) konumu d�nd�r�l�r
��k:
    pop edi
    leave
    ret

; _asm_uzunluk fonksiyonu:
; girilen dizge uzunlu�unu d�nd�r�r
; unsigned asm_uzunluk (const krk *);
; parametreler:
;   kaynak - girilen dizgeyi i�aretler
; EAX i�inde d�nen de�er:
;   dizgedeki krk say�s� (son 0/NULL say�lmaz)

    %define kaynak [ebp + 8]
_asm_uzunluk:
    enter 0, 0
    push edi

    mov edi, kaynak	; edi = dizge ba��n� i�aretler
    mov ecx, 0FFFFFFFFh ; ECX sayaca eny�ksek say� atan�r
    xor al,al		; al = 0
    cld

    repnz scasb	; EDI sonland�r�c� 0'a dek taran�r, saya� da bir fazla indirgenir
    mov eax, 0FFFFFFFEh ; enb�kten 1 eksik say� atan�r
    sub eax, ecx	; uzunluk = 0FFFFFFFEh - ecx

    pop edi
    leave
    ret

; _asm_dzgkopya fonksiyonu:
; Girilen dizgeyi kopyalar
; void asm_dzgkopya (char * hedef, const char * kaynak);
; parametreler:
;   hedef - kopyalanacak dizge ba��n� i�aretler
;   kaynak - kopyalanacak tampon ba��n� i�aretler

    %define hedef [ebp + 8]
    %define kaynak  [ebp + 12]

_asm_dzgkopya:
    enter 0, 0
    push esi
    push edi

    mov edi, hedef
    mov esi, kaynak
    cld

d�ng�:
    lodsb		; kaynak'tan AL'e oku & inc si
    stosb		; AL'dan hedefe yaz & inc di
    or al, al		; �art bayraklar�n� kur
    jnz d�ng�	; kaynak biti� 0'a eri�ilmediyse d�ng�'ye devam

    pop edi
    pop esi
    leave
    ret