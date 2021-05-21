; pcasm5b.asm: Girilen karakteri cümlede arama ve dizge uzunluðunu hesaplama örneði.
;
; nasm -fwin32 pcasm5b.asm
; gcc -m32 pcasm5b.obj pcasm5b.c
;---------------------------------------------------------------------------------------------------------------------------------

; Çok boyutlu diziler, bellekte gerçekte tek boyutlu diziler gibi adreslenirler.
; int a[3][2] dizisinin bellekte endeks/eleman satýrvari dizilimi: 0/a[0][0], 1/a[0][1], 2/a[1][0], 3/a[1][1], 4/a[2][0], 5/[2][1]
; Endeks hesaplamayý 2*i+j (her satýrda 2 elemen) formülle yapar.
;
;; mov eax, [ebp - 44]	; i'nin konumu = ebp - 44
;; sal eax, 1		; Shift-left ile i*2
;; add eax, [ebp - 48]		; j'nin konumu=ebp-46; i*2 + j
;; mov eax, [ebp + 4*eax - 40]	; a[0][0]'ýn adres i= ebp - 40
;; mov [ebp - 52], eax	; x=2*i+j sonucunu [ebp - 52]'ye taþý
;
; Ýki boyutlu N kolonlu formül = N*i+j
; 
; Üç boyutlu int b[4][3][2]=b[L][M][N] ise endeks formulü = M*N*i + N*j + k; ilk L gözönüne alýnmaz
; void f(int *a[]); void f(int a[][2]); void f(int a[][4][3][2]; geçerli bellek tahsisleridir.
;
; Dizgeler dizi gibi artan/azalan iþlem görür, yönü DF/DirectionFlag belirler, ESI yada EDI endeks kayýtçýlarla takip edilir.
; CLD/ClearDF artandýr; STD/SetDF azalandýr.
;
; Dizgelerin Byte, Word, DoubleWord olarak okunma/LOD ve yazma/STO komutlarý:
;; LODSB AL = [DS:ESI]	; ESI = ESI ± 1
;; STOSB [ES:EDI] = AL	; EDI = EDI ± 1
;; LODSW AX = [DS:ESI]	; ESI = ESI ± 2
;; STOSW [ES:EDI] = AX	; EDI = EDI ± 2
;; LODSD EAX = [DS:ESI]	; ESI = ESI ± 4
;; STOSD [ES:EDI] = EAX	; EDI = EDI ± 4
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
;; döngü:
;; lodsd	; LoadStringDouble, oku
;; stosd	; StoreStringDouble, yaz
;; loop döngü
;
; Hafýzadaki dizgenin Byte, Word, DoubleWord taþýnmasý:
;; MOVSB byte [ES:EDI] = byte [DS:ESI]		; ESI = ESI ± 1	; EDI = EDI ± 1
;; MOVSW word [ES:EDI] = word [DS:ESI]	; ESI = ESI ± 2	; EDI = EDI ± 2
;; MOVSD dword [ES:EDI] = dword [DS:ESI]	; ESI = ESI ± 4	; EDI = EDI ± 4
;
; 10 elemanlý sýfýr dizisi
;; segment .bss
;; dizi resd 10
;; segment .text
;; cld	; artan
;; mov edi, dizi
;; mov ecx, 10
;; xor eax, eax	; eax=0
;; rep stosd	; REPeat ECX kere; dizi=eax=0
;
; Dizgelerde CMP için CMPSx, x=Byte/Word/Doubleword kýyaslar
; SCASx ise SCAN tarar, araþtýrýr
;; CMPSB karþýlaþtýr byte [DS:ESI] ve byte [ES:EDI]		; ESI = ESI ± 1	; EDI = EDI ± 1
;; CMPSW karþýlaþtýr word [DS:ESI] ve word [ES:EDI]	; ESI = ESI ± 2	; EDI = EDI ± 2
;; CMPSD karþýlaþtýr dword [DS:ESI] ve dword [ES:EDI]	; ESI = ESI ± 4	; EDI = EDI ± 4
;; SCASB tara AL ve [ES:EDI]		; EDI ± 1
;; SCASW tara AX and [ES:EDI]	; EDI ± 2
;; SCASD tara EAX and [ES:EDI]	; EDI ± 4
;
; 100 elemanlý dizide 12 deðerli elemaný arama örneði:
;; segment .bss
;; dizi resd 100
;; segment .text
;; cld
;; mov edi, dizi	; Diziyi bellekte baþlatma göstergeci
;; mov ecx, 100	; Dizi eleman sayýsý
;; mov eax, 12	; Aranan deðer
;; döngü:
;; scasd
;; je bulundu
;; loop döngü
;;; Bulunamazsa buraya gelir
;; jmp ilerle
;; bulundu:
;; sub edi, 4	; edi þimdi 12 deðerini içeren dizi elemanýný iþaret eder
;;; Programa devam
;; ilerle:
;
; Þartlý tekrarý kýrma: REPZ/RepeatZero, REPE/RepeatEqual, REPNZ/RepeatNotZero, REPNE/RepeatNotEqual
;
; Ýki bellek bloðunun eþitliði karþýlaþtýrmasý örneði:
;; segment .text
;; cld
;; mov esi, blok1	; Ýlk blok baþlangýç adresi
;; mov edi, blok2	; Ýkinci blok baþlangýç adresi
;; mov ecx, EBAT	; Bloklarýn Byte ebatý
;; repe cmpsb	; ZF=1'e dek takrarlar
;; je eþit		; Eðer ZF=1 ise
;;; Bloklar eþit deðilse kýr
;; jmp ilerle
;; eþit:
;;; Eþitse buradadýr
;; ilerle:
;---------------------------------------------------------------------------------------------------------------------------------

    global _asm_kopyala, _asm_bul, _asm_uzunluk, _asm_dzgkopya

	segment .text
; _asm_kopyala fonksiyonu:
; Test dizgesini diðer bir dizgeye kopyalar
; C prototipi:
; void asm_kopyala (void * hedef, const void * kaynak, unsigned ebat);
; parametreler:
;   hedef - kopyalanacak bellek tamoununu iþaretler
;   kaynak - kopyalanan bellek tamponunu iþaretler
;   ebat - kopyalanacak byte sayýsý

; Bellek adreslerini adlarla tanýmlayalým

    %define hedef [ebp+8]
    %define kaynak  [ebp+12]
    %define ebat   [ebp+16]
_asm_kopyala:
    enter 0, 0
    push esi
    push edi

    mov esi, kaynak	; esi = kopyalanacak tampon adresi
    mov edi, hedef	; edi = kopyalanan tampon adresi
    mov ecx, ebat	; ecx = kopyalanacak byte sayýsý

    cld		; ClearDirection-flag, artan
    rep movsb	; movsb/MoveStringByte esi-->edi taþýma komutunu ECX kere tekrarla

    pop edi
    pop esi
    leave
    ret

; _asm_bul fonksiyonu:
; Bellekteki test dizgesini girilen krk için araþtýrýr
; void * asm_bul (const void * kaynak, char hedef, unsigned ebat);
; parametreler:
;   kaynak - araþtýrýlacak tamponu iþaretler
;   dedef - araþtýrýlan deðeri iþaretler
;   ebat - tampondaki byte sayýsý
; dönen deðer:
;   eðer hedef bulunduysa, tampondaki ilk bulunan konumun iþaretçisi döner
;   deðilse
;     NULL/hiç döner
; NOT: hedef byte olsa da, yýðýna dword deðer olarak konur
;       Byte deðeri alt 8-bit'e depolanýr

    %define kaynak [ebp+8]
    %define hedef [ebp+12]
    %define ebat [ebp+16]

_asm_bul:
    enter 0, 0
    push edi

    mov eax, hedef	; al araþtýrýlacak krk'i içerir
    mov edi, kaynak
    mov ecx, ebat
    cld		; artan

    repne scasb	; scansb/ScanStringByte araþtýr ta ki ECX == 0 veya [ES:EDI] == AL

    je buldum	; ZF=1 ise bulunmuþtur
    mov eax, 0	; bulunmadýysa EAX=0/NULL döndür
    jmp short çýk
buldum:
    mov eax, edi
    dec eax		; bulunduysa (DI - 1) konumu döndürülür
çýk:
    pop edi
    leave
    ret

; _asm_uzunluk fonksiyonu:
; girilen dizge uzunluðunu döndürür
; unsigned asm_uzunluk (const krk *);
; parametreler:
;   kaynak - girilen dizgeyi iþaretler
; EAX içinde dönen deðer:
;   dizgedeki krk sayýsý (son 0/NULL sayýlmaz)

    %define kaynak [ebp + 8]
_asm_uzunluk:
    enter 0, 0
    push edi

    mov edi, kaynak	; edi = dizge baþýný iþaretler
    mov ecx, 0FFFFFFFFh ; ECX sayaca enyüksek sayý atanýr
    xor al,al		; al = 0
    cld

    repnz scasb	; EDI sonlandýrýcý 0'a dek taranýr, sayaç da bir fazla indirgenir
    mov eax, 0FFFFFFFEh ; enbükten 1 eksik sayý atanýr
    sub eax, ecx	; uzunluk = 0FFFFFFFEh - ecx

    pop edi
    leave
    ret

; _asm_dzgkopya fonksiyonu:
; Girilen dizgeyi kopyalar
; void asm_dzgkopya (char * hedef, const char * kaynak);
; parametreler:
;   hedef - kopyalanacak dizge baþýný iþaretler
;   kaynak - kopyalanacak tampon baþýný iþaretler

    %define hedef [ebp + 8]
    %define kaynak  [ebp + 12]

_asm_dzgkopya:
    enter 0, 0
    push esi
    push edi

    mov edi, hedef
    mov esi, kaynak
    cld

döngü:
    lodsb		; kaynak'tan AL'e oku & inc si
    stosb		; AL'dan hedefe yaz & inc di
    or al, al		; þart bayraklarýný kur
    jnz döngü	; kaynak bitiþ 0'a eriþilmediyse döngü'ye devam

    pop edi
    pop esi
    leave
    ret