; tut19.asm: On elemanlý dizi sayýlarýnýn toplamýný gösterme örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 5
;----------------------------------------------------------------------------------------------------------------------------------------------
; ==== DÝZGELER ====
; Deðiþken uzunluktaki dizgeleri assembler'da tespit için, uzunluk alenen yazýlabilir:
; Mesaj db "Merhaba, dünya!", 0xa
; Uzunluk equ 15 ; dizgemizin sayabileceðiniz krk sayýsý
;
; $ sembolüyle otomatikmen tespit:
; Mesaj db "Merhaba, dünta!", 0xa
; Uzunluk equ $ - Mesaj
; 
; Yada sabite sonuna konulan sýfýr dizge sonunun gözcüsüdür:
; Mesaj db "Merhaba, dünta!", 0xa, 0
;
; komut kaynak, hedef ; kaynak 32-bit için ESI, 16-bit için SI/SourceIndex; hedef 32-bit için EDI, 16-bit için DI/DestinationIndex
TemelKomutlar Ýþlemciler         ByteÝþlem  WordÝþlem  DWÝþlem
MOVS                ES:DI, DS:SI  MOVSB     MOVSW      MOVSD	; MoveString, ExtraSegment:DestinationIndex, DataSegment:SourceIndex; Taþý
LODS                 AX, DS:SI       LODSB      LODSW       LODSD	; LoadString; Bellekten (toplayýcý) kayýtçýya oku
STOS                 ES:DI, AX        STOSB      STOSW       STOSD	; StoreString; Kayýtçýdan belleðe yaz
CMPS                 DS:SI, ES:DI  CMPSB      CMPSW       CMPSD	; CompareString; Bellekteki kaynakla hedefi kýyasla
SCAS                 ES:DI, AX        SCASB      SCASW       SCASD	; SourceCompareAccumulatorString; Bellekkteki hedefle kayýtöýyý kýyasla
;
; REP MOVSB ; Repeat ile CX sayaç sýfýrlanýncaya kez tekrarla
; REPE veya REPZ, ZF=1 ise veya CX=0 deðilse tekrarla
; REPNE veya REPNZ, ZF=0 ise veya CX=0 deðilse tekrarla
; CLD ; ClearDirection, DF=0 ve dizge üzerindeki iþlem soldan saða
; STD , SetDirection, DF=1 ve iþlem saðdan sola
;
; ==== DÝZÝLER ====
; Diziler ilk adresi ve artan byte takibiyle kurulur, normalde tek deðiþkenden farký yoktur.
; AYLAR1 DW 12	; DataWord, kelime=2 byte
; AYLAR2 DW 0CH
; AYLAR3 DW 1100B
; Her üçdeðiþken de aynýdýr, ayný deðeri taþýrlar.
; SAYILAR DW 34, 45, 56, 67, 75, 89	; bellekte 2*6=12 ardýþýk byte yeri kaplarlar: SAYILAR, SAYILAR+2,.. SAYILAR+10
;
; Aþaðýdaki herüç yazýlým da ayný geçerliliktedir:
; ENVANTER DW 0
; ENVANTER DW 0
; ...
; ENVANTER DW 0		; Toplam 8 adet
; ENVANTER DW 0, 0, 0, 0, 0, 0, 0, 0
; ENVANTER TIMES 8 DW 0
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov eax, 10	; toplanacak dizi eleman sayýsý
    mov ebx, 0	; EBX toplamý sonuçlandýrýncaya dektutacak
    mov ecx, dizi	; ECX dizi'nin ilk adresini iþaret edecek
üst:
    add ebx, [ecx]	; ebx +=ecx: aktüel ECX deðerini EBX'e ekle
    add ecx,1	; birsonraki byte'ý iþaret et
    dec eax		; eax -=1:sayaç olarak kullnýlan EAX'ý bir düþür
    jnz üst		; dec eax sonucu ZF=1 deðilse üst'e atla
bitti:
    add ebx, "0"	; ascii'ye çevir
    mov [toplam], ebx	; EBX sonucu toplam'a aktar
göster:
    mov edx,1	; toplam'ýn uzunluðu db=1 byte
    mov ecx, toplam	; yazdýrýlacak toplam
    mov ebx, 1	; 1=ekran
    mov eax, 4	; 4=yaz
    int 0x80

    mov eax, 1	; 1=Çýk
    int 0x80

	section .data
    global dizi
    dizi: db 2, 0, 3, 0, 0, 0, 2, 0, 0, -2
    toplam: db 0