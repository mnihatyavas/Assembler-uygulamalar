; tut01.asm: Merhaba linux nasm assemler örneði.
;
; $nasm -f elf *.asm
; ld -m elf_i386 -s -o demo *.o
; $demo
; Merhaba, çevrimiçi linux nasm assembler dünyasý!
;--------------------------------------------------------------------------------------------------------------------------
; ===TEMEL DÝZÝLÝM===
; Assembler bilgisayar donanýmlarýndan iþlemci, kayýtçýlar ve belleði kullanarak farklý veri tiplerini
; iþler: Byte (8bit), Word/Kelime (2 byte), Doubleword/Çiftkelime (4 byte), Quadword/Dörtlükelime
; (8 byte), Paragraf (16 byte), KB (1024 byte), MB (1,048,576 byte).
; 1byte=11111111=1+2+4+8+16+32+64+128=255=2^8-1
; 1 byte 8 bit yada 2 adet dörderli bitli hex olarak okunabilir: 0=0=0, 1=1=1, 2=01=2, 3=11=3, 4=100=4,
; 5=101=5, 6=110=6, 7=111=7, 8=1000=8, 9=1001=9, 10=1010=A, 11=1011=B, 12=1100=C, 13=1101=D,
; 14=1110=E, 15=1111=F. Hex onaltýlý büyük/küçük harf farketmez.
; Ýkili 1000 1100 1101 0001=8CD1 hex, Hex FAD8=1111 1010 1101 1000 ikili
; Ondalýk 60+42=102 ise ikili 00111100 + 00101010 = 01100110
; Sayýnýn negatifi, pozitif ikilinin tamlayýcýsý + 1'dir. +53=00110101, tamlayýcýsý=11001010 +1=11001011=-53
; Ondalýk çýkarma 53-42=11 ise ikili +42=00101010, -42=11010101+1=11010110, 53+(-42)=00001011 ve
; taþan 1 kaybolur.
;
; Komutlar hafýzadan getirilir, çözümlenir, iþlenir. bellekten alýnan 2507H kelime, kayýtçýya tersten konur.
; Ýlk alýnan düþük byte'a, ikincisi yüksek byte'a aktarýlýr.
; Bellek adresi ya mutlaktýr, yada baþlangýç+telafi adreslidir.
; 
; Bu kursta NASM/NetwideAssembler assembler ve çevrimiçi Linux iþletim sistemi kullanýlacaktýr, örnek assembler
; kodlarý çevrimiçi www.tutorialspoint.com'un mevcut Linuz sistemine kopyalanýp çalýþtýrýlacaktýr.
;
; Bir assembler programý 3 bölümlüdür: section/segment data (ilk deðerli sabitler), bss (deðiþkenler), text (kodlama).
; section .text
;     global _start
; _start:
;
; Yorumlar kodlu/kodsuz satýrda ; ile baþlarlar.
; add eax, ebx	; eax += ebx
;
Bir assembler ifadesinin genel yazýlýmý: [etiket] komut [parametreler] [; yorum]
; Ýþlemci komutu mecburi, diðerleri tercihidir. Birkaç örnek:
; INC SAYAÇ ; SAYAÇ += 1
; MOV TOPLAM, 48 ; TAPLAM = 48
; ADD AH, BH ; AH += BH
; AND DEÐÝÞKEN1, 128 ; Bellek DEÐÝÞKEN içeriðini 128'le AND'le
; ADD DEÐÞKEN2, 10 ; DEÐÝÞKEN2 += 10
; MOV AL, 10 ; AL = 10
;--------------------------------------------------------------------------------------------------------------------------

	section .data
    Mesaj db "Merhaba, çevrimiçi linux nasm assembler dünyasý!", 0xa	; =10: yazdýrýlacak dizge
    Uzunluk equ $ - Mesaj	; Mesaj dizgesinin uzunluðu

    global _start	; baðlayýcý/linker=ld için beyaný mecburidir
	section .text
_start:	; kodlamaya ilk giriþ noktasý
    mov edx, Uzunluk		; Mesaj uzunluðu, EDX/DataRegister/VeriKayýtçý
    mov ecx, Mesaj		; Yazdýrýlacak Mesaj, ECX/CounterRegister/SayaçKayýtçý
    mov ebx,1		; Yazdýrýlacak dosya no=1 (stdout/standart-çýktý), EBX/BaseRegister/TemelKayýtçý
    mov eax, 4		; Sistem call/çaðýr no=4 (sys_write/yaz), EAX/AccumulatorRegister/ToplayýcýKayýtçý
    int 0x80			; Kernel'i yazdýrma için call/çaðýr
    mov eax,1		; Sistem çaðýr no=1 (sys_exit/çýk)
    int 0x80			; Kernell'i çýkýþ için çaðýr
