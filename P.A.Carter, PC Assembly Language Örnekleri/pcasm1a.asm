; pcasm1a.asm: Girilen iki tamsayýnýn toplamýnýn sunulmasý örneði.
;
; Bu ilk ASM programý sizden 2 tamsayý girmenizi ister ve sonra toplamýný ekrana yansýtýr.
;
; nasm -fwin32 pcasm1a.asm
; nasm -fwin32 pcasm1a.asm -l pcasm1a.lst
; gcc -m32 pcasm1a.obj pcasm.c asm_io.obj -o pcasm1a.exe
;-------------------------------------------------------------------------------------------------------------------------------------

; Hexadesimal/onaltýlý, desimal/onlu ve binary/ikili çevrimleri:
; 2BD16 = 2 × 16^2 + 11 × 16^1 + 13 × 16^0 = 512 + 176 + 13 = 701
; 24D16 = 0010 0100 11012
; Hafýza/memory birimleri: word=2 bytes, double word=4 bytes, quad word=8 bytes, paragraph=16 bytes
;
; 8086 16-bit CPU registers/kayýtçý: (real mode/gerçek kip)
; Genel amaçlý kayýtçýlar: AX/accumulator, BX/base, CS/code, DX/data;  AX=AH+AL
; Index/endeks kayýtçýlar: SI, DI
; Pointer/iþaretçi kayýtçýlar: BP/BasePointer/TemelÝþaretçi, SP/Stack/Yýðýn, IP/Instruction/Talimat
; Segment/bölüm kayýtçýlar: CS/CodeSegment, DS/Data, SS/Stack, ES/Extra
; FLAGS/bayraklar: 0/1
;
; 80386 32-bit kayýtçýlar: (paged 32-bit protected mode/korumalý kip)
; EAX/ExtendedAccumulator, EBX, ECX, EDX, ESI, EDI, EBP, ESP, CS, DS, SS, ES, FS, GS, EFAGS
;
; InterruptHandler/kesinti yönetimi program yada harici (fare, dokunmatik ekran, klavye vb) kesintilerle,
; akýþý keser, sonra yeniden kaldýðý yerden devam eder.
;
; Makine dili: 03 C3
; Assembler dili: add eax, ebx
; mov eax, 3 ; EAX<==3 (3 anlýk iþlenen'dir)
; mov bx, ax ; BX<==AX
; add eax, 4 ; eax = eax + 4
; add al, ah ; al = al + ah
; sub bx, 10 ; bx = bx - 10
; sub ebx, edi ; ebx = ebx - edi
; inc ecx ; ecx++
; dec dl ; dl--
;
; equ direktifi: sembol equ deðer ; sembol sonradan deðiþtirilemez
; %define EBAT 100 ; EBAT tanýmlý makrosu sonradan deðiþtrirlebilir ; assembler % ile C # eþdeðerdir
; mov eax, EBAT
;
; RESX and DX direktif harfleri: byte B, word W, double word D, quad word Q, ten bytes T
; segment .data ;hafýza konumlu etiket adlarý ve deðerleri:
; L1 db 0 ; byte etiketli L1=0
; L2 dw 1000 ; word etiketli L2=1000
; L3 db 110101b ; byte etiketli L3=110101 byte (53 ondalýk)
; L4 db 12h ; byte etiketli L4=12 hex (18 ondalýk)
; L5 db 17o ; byte etiketli L5=17 octal (15 ondalýk)
; L6 dd 1A92h ; double word etiketli L6=1A92 hex
; L7 resb 1 ; 1 uninitialized byte ; reserve byte (byte tahsisi)
; L8 db "A" ; byte etiketli L8=A ascii kod (65)
; L9 db 0, 1, 2, 3 ; 4 bytes tanýmlar
; L10 db "w", "o", "r", ’d’, 0 ; "word" C dizgesini tanýmlar
; L11 db ’word’, 0 ; L10 ile aynýdýr
; L12 times 100 db 0 ; 100 kere (db 0)
; L13 resw 100 ; reserve/tahsis 100 adet word/kelime/2-byte=16 bit
;
; L1 adres
; [L1] adresteki byte deðer
; mov al, [L1] ; AL=[L1] byte deðer
; mov eax, L1 ; EAX = L1 byte adres
; mov [L1], ah ; AH=[L1] byte deðer
; mov eax, [L6] ; EAX=[L6] dd çift kelime deðer
; add eax, [L6] ; EAX = EAX + [L6] çift kelimelik deðer
; add [L6], eax ; [L6] += EAX
; mov al, [L6] ; AL=[L6] çift kelimenin düþük byte kelimesi
;
; mov [L6], 1 ; hata (operation size not specified error - byte, word, dword, qword, tword?) yapabilir
; mov dword [L6], 1 ; hatasýz, çift kelimeye 1 kopyalar
;
; Yazarýn kendi okuma-yazma rutinleri: print_int, print_char, print_string, print_nl, read_int, read_char
; Türkçeleþtirilmesi: yaz_tms, yaz_krk, yaz_dizge, yaz_hiç, oku_tms, oku_krk
; Rutinlerin programa duhulü: %include "asm_io.inc"
;-------------------------------------------------------------------------------------------------------------------------------------

%include "asm_io.inc"
;
; Ýlkdeðerli veriler .data bölümüne konulur
;
segment .data
;
; Bu etiketler çýktý için kullanýlacak olan dizgelerdir
;
ileti1 db    "Ýlk tamsayýyý girin: ", 0       ; nul 0 sonlandýrýcý (ascii=0) unutulmasýn
ileti2 db    "Ýkinci tamsayýyý girin: ", 0
çýktý1 db    "Girilenler: ", 0
çýktý2 db    " ve ", 0
çýktý3 db    "Bunlarýn toplamý: ", 0
;
; Ýlkdeðersiz veriler .bss bölümüne konulur
;
segment .bss		; bss=block started by symbol, sembolle baþlatýlan blok
;
; Bu etiketler girdileri depolayan duble kelimedir
;
girdi1  resd 1		; res-D: double word
girdi2  resd 1
;
; Kodlama .text bölümüdür
;
segment .text
    global  _esas_kodlama	; C ve assembler fonksiyon ve global deðiþkenler _ ile baþlar
_esas_kodlama:
    enter 0, 0		; kurulum rutini
    pusha

    mov eax, ileti1		; Ýlk verigiriþi iletisini yansýt
    call yaz_dizge

    call oku_tms		; Ýlk tamsayýyý oku
    mov [girdi1], eax		; Deðeri girdi1'e sakla

    mov eax, ileti2		; Ýkinci verigiriþ iletisini yansýt
    call yaz_dizge

    call oku_tms		; Ýkinci tamsayýyý oku
    mov [girdi2], eax		; Deðeri girdi2'ye sakla
    call yaz_hiç		; Satýrbaþý

    mov eax, [girdi1]		; eax = dword girdi1
    add eax, [girdi2]		; eax += dword girdi2
    mov ebx, eax		; ebx = eax
    kayýtçýlarý_boþalt 1	; Kayýtçýlarý boþalt
    belleði_boþalt 2, çýktý1, 1	; Hafýzayý boþalt
    call yaz_hiç		; Satýrbaþý
;
; Sonuçlarý birkaç adýmda çýktýya yansýt
;
    mov eax, çýktý1
    call yaz_dizge		; Ýlk mesajý yansýt
    mov eax, [girdi1]
    call yaz_tms		; Ýlk  girdi1'i yansýt
    mov eax, çýktý2
    call yaz_dizge		; Ýkinci mesajý yansýt
    mov eax, [girdi2]
    call yaz_tms		; Ýkinci girdi2'yi yansýt
    call yaz_hiç		; Satýrbaþý
    mov eax, çýktý3
    call yaz_dizge		; Son mesajý yansýt
    mov eax, ebx
    call yaz_tms		; Toplamý  (ebx) yansýt
    call yaz_hiç		; Satýrbaþý

    popa			; Yýðýný a/all sil
    mov eax, 0		; CPU kayýtçýyý sýfýrla
    leave
    ret			; Çaðrýlan C'ye geridön
