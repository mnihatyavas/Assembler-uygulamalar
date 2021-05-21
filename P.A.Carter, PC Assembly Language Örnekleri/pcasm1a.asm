; pcasm1a.asm: Girilen iki tamsay�n�n toplam�n�n sunulmas� �rne�i.
;
; Bu ilk ASM program� sizden 2 tamsay� girmenizi ister ve sonra toplam�n� ekrana yans�t�r.
;
; nasm -fwin32 pcasm1a.asm
; nasm -fwin32 pcasm1a.asm -l pcasm1a.lst
; gcc -m32 pcasm1a.obj pcasm.c asm_io.obj -o pcasm1a.exe
;-------------------------------------------------------------------------------------------------------------------------------------

; Hexadesimal/onalt�l�, desimal/onlu ve binary/ikili �evrimleri:
; 2BD16 = 2 � 16^2 + 11 � 16^1 + 13 � 16^0 = 512 + 176 + 13 = 701
; 24D16 = 0010 0100 11012
; Haf�za/memory birimleri: word=2 bytes, double word=4 bytes, quad word=8 bytes, paragraph=16 bytes
;
; 8086 16-bit CPU registers/kay�t��: (real mode/ger�ek kip)
; Genel ama�l� kay�t��lar: AX/accumulator, BX/base, CS/code, DX/data;  AX=AH+AL
; Index/endeks kay�t��lar: SI, DI
; Pointer/i�aret�i kay�t��lar: BP/BasePointer/Temel��aret�i, SP/Stack/Y���n, IP/Instruction/Talimat
; Segment/b�l�m kay�t��lar: CS/CodeSegment, DS/Data, SS/Stack, ES/Extra
; FLAGS/bayraklar: 0/1
;
; 80386 32-bit kay�t��lar: (paged 32-bit protected mode/korumal� kip)
; EAX/ExtendedAccumulator, EBX, ECX, EDX, ESI, EDI, EBP, ESP, CS, DS, SS, ES, FS, GS, EFAGS
;
; InterruptHandler/kesinti y�netimi program yada harici (fare, dokunmatik ekran, klavye vb) kesintilerle,
; ak��� keser, sonra yeniden kald��� yerden devam eder.
;
; Makine dili: 03 C3
; Assembler dili: add eax, ebx
; mov eax, 3 ; EAX<==3 (3 anl�k i�lenen'dir)
; mov bx, ax ; BX<==AX
; add eax, 4 ; eax = eax + 4
; add al, ah ; al = al + ah
; sub bx, 10 ; bx = bx - 10
; sub ebx, edi ; ebx = ebx - edi
; inc ecx ; ecx++
; dec dl ; dl--
;
; equ direktifi: sembol equ de�er ; sembol sonradan de�i�tirilemez
; %define EBAT 100 ; EBAT tan�ml� makrosu sonradan de�i�trirlebilir ; assembler % ile C # e�de�erdir
; mov eax, EBAT
;
; RESX and DX direktif harfleri: byte B, word W, double word D, quad word Q, ten bytes T
; segment .data ;haf�za konumlu etiket adlar� ve de�erleri:
; L1 db 0 ; byte etiketli L1=0
; L2 dw 1000 ; word etiketli L2=1000
; L3 db 110101b ; byte etiketli L3=110101 byte (53 ondal�k)
; L4 db 12h ; byte etiketli L4=12 hex (18 ondal�k)
; L5 db 17o ; byte etiketli L5=17 octal (15 ondal�k)
; L6 dd 1A92h ; double word etiketli L6=1A92 hex
; L7 resb 1 ; 1 uninitialized byte ; reserve byte (byte tahsisi)
; L8 db "A" ; byte etiketli L8=A ascii kod (65)
; L9 db 0, 1, 2, 3 ; 4 bytes tan�mlar
; L10 db "w", "o", "r", �d�, 0 ; "word" C dizgesini tan�mlar
; L11 db �word�, 0 ; L10 ile ayn�d�r
; L12 times 100 db 0 ; 100 kere (db 0)
; L13 resw 100 ; reserve/tahsis 100 adet word/kelime/2-byte=16 bit
;
; L1 adres
; [L1] adresteki byte de�er
; mov al, [L1] ; AL=[L1] byte de�er
; mov eax, L1 ; EAX = L1 byte adres
; mov [L1], ah ; AH=[L1] byte de�er
; mov eax, [L6] ; EAX=[L6] dd �ift kelime de�er
; add eax, [L6] ; EAX = EAX + [L6] �ift kelimelik de�er
; add [L6], eax ; [L6] += EAX
; mov al, [L6] ; AL=[L6] �ift kelimenin d���k byte kelimesi
;
; mov [L6], 1 ; hata (operation size not specified error - byte, word, dword, qword, tword?) yapabilir
; mov dword [L6], 1 ; hatas�z, �ift kelimeye 1 kopyalar
;
; Yazar�n kendi okuma-yazma rutinleri: print_int, print_char, print_string, print_nl, read_int, read_char
; T�rk�ele�tirilmesi: yaz_tms, yaz_krk, yaz_dizge, yaz_hi�, oku_tms, oku_krk
; Rutinlerin programa duhul�: %include "asm_io.inc"
;-------------------------------------------------------------------------------------------------------------------------------------

%include "asm_io.inc"
;
; �lkde�erli veriler .data b�l�m�ne konulur
;
segment .data
;
; Bu etiketler ��kt� i�in kullan�lacak olan dizgelerdir
;
ileti1 db    "�lk tamsay�y� girin: ", 0       ; nul 0 sonland�r�c� (ascii=0) unutulmas�n
ileti2 db    "�kinci tamsay�y� girin: ", 0
��kt�1 db    "Girilenler: ", 0
��kt�2 db    " ve ", 0
��kt�3 db    "Bunlar�n toplam�: ", 0
;
; �lkde�ersiz veriler .bss b�l�m�ne konulur
;
segment .bss		; bss=block started by symbol, sembolle ba�lat�lan blok
;
; Bu etiketler girdileri depolayan duble kelimedir
;
girdi1  resd 1		; res-D: double word
girdi2  resd 1
;
; Kodlama .text b�l�m�d�r
;
segment .text
    global  _esas_kodlama	; C ve assembler fonksiyon ve global de�i�kenler _ ile ba�lar
_esas_kodlama:
    enter 0, 0		; kurulum rutini
    pusha

    mov eax, ileti1		; �lk verigiri�i iletisini yans�t
    call yaz_dizge

    call oku_tms		; �lk tamsay�y� oku
    mov [girdi1], eax		; De�eri girdi1'e sakla

    mov eax, ileti2		; �kinci verigiri� iletisini yans�t
    call yaz_dizge

    call oku_tms		; �kinci tamsay�y� oku
    mov [girdi2], eax		; De�eri girdi2'ye sakla
    call yaz_hi�		; Sat�rba��

    mov eax, [girdi1]		; eax = dword girdi1
    add eax, [girdi2]		; eax += dword girdi2
    mov ebx, eax		; ebx = eax
    kay�t��lar�_bo�alt 1	; Kay�t��lar� bo�alt
    belle�i_bo�alt 2, ��kt�1, 1	; Haf�zay� bo�alt
    call yaz_hi�		; Sat�rba��
;
; Sonu�lar� birka� ad�mda ��kt�ya yans�t
;
    mov eax, ��kt�1
    call yaz_dizge		; �lk mesaj� yans�t
    mov eax, [girdi1]
    call yaz_tms		; �lk  girdi1'i yans�t
    mov eax, ��kt�2
    call yaz_dizge		; �kinci mesaj� yans�t
    mov eax, [girdi2]
    call yaz_tms		; �kinci girdi2'yi yans�t
    call yaz_hi�		; Sat�rba��
    mov eax, ��kt�3
    call yaz_dizge		; Son mesaj� yans�t
    mov eax, ebx
    call yaz_tms		; Toplam�  (ebx) yans�t
    call yaz_hi�		; Sat�rba��

    popa			; Y���n� a/all sil
    mov eax, 0		; CPU kay�t��y� s�f�rla
    leave
    ret			; �a�r�lan C'ye gerid�n
