; asmtutor16.asm:  Klavyeden girilen çoklu tamsayýlarýn toplamlarý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; prog 20 1000 317
; Klavyeden girilen çoklu tamsayý argümanlarýn toplamý: 1337
; NOT: Çevrimiçi Nasm Assembler servislerden hiçbiri include/klavyeGiriþi/komutSatýrlýArgümanlar olmadýðýndan,
; yada sonuç prog.exe'yi sana sunmadýklarýndan, exe'si ile argümanlarýn testi yapýlamamaktadýr.
;----------------------------------------------------------------------------------------------------------------------------------
; ===16.Çoklu Klavye Argümanýn Toplamý===
; Klavyeden girilen çoklu argüman sayýsý POP ECX sayacýna, programýn kendisiyse icabýnda POP EDX'le
; yýðýndan alýnabilir. Sonraki ECX sayaç adedince yapýlan POP EAX'lar herbir klavye giriþ argümanýný yýðýndan alýr.
; Klavye giriþleri dizgesel olup ascii tablo karþýlýklarýný tamsayýya (atoi: ascii to integer) çevirip (tamsayý deðilse
; 0=sýfýr farzedip) bu tamsayýlarý toplar ve sonucu ekrana yansýtýrýz.
; Çok haneli rakamlarda herbir hane (ascii48-57) 10 ile çarpýlarak öncekiyle toplanmalý, son hanedeki fazlalýk
; çarpýmsa DIV 10 ile geri alýnmalýdýr. Ayrýca argüman sýfýrsa 10'lu çarpým ve bölüm olmayacaktýr.
; Önce functions.asm=asmtutor05x.asm INCLUDE harici dosyaya atoi=adant (AsciiDanTamsayýya) altrutini
; ilave etmeliyiz.
; Ýþlemlerde sadece 0-9/ascii48-57 tek btye kullanýldýðýndan fuzuli 32-bitlik EBX, yada 16-bitlik BX deðil, sadece
; 8-bit=1byte'lýk BL (BH deðil) kullanýlacaktýr.
; Toplam argüman sayacý olarak ECX, tek argümandaki tamsayý rakam adedi döngü devam kontrolü içinse ilk ascii48
; küçüðüne yada ascii57 büyüðüne rastlama þartý kullanýlýr ve burada ECX sayacý sýfýrdan farklýysa son deðerin
; 10 ile bölümü yapýlýr (ECX=0 deðilse 10'a bölünmez).
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    Mesaj db "Klavyeden girilen çoklu tamsayý argümanlarýn toplamý: ", 0h

	SECTION .text
    global _start
_start:
    pop ecx		; Klavyeden girilen argüman sayýsý (program adý dahil)
    pop edx	; Argüman 0 (program adý)
    sub ecx, 1	; Program adý sayaçtan düþülür
    mov edx, 0	; Argümanlarýn toplamý kayýtçýsý
birsonraki_arguman:
    cmp ecx, 0h
    jz argumanlar_bitti ; ECX=0 ise argümanlar bitmiþtir, sonlandýr
    pop eax	; Klavyeden girilen aktüel argümaný yýðýndan al
    call adant	; AsciiDanTamsayýya fonksiyonunu çaðýrýp, aktüel argümaný tamsayýya çevir
    add edx, eax	; EDX +=EAX (Aktüel tamsayý argümaný genele topla)
    dec ecx		; Sýfýr kontrolu için argüman sayacýný bir düþür
    jmp birsonraki_arguman
argumanlar_bitti:
    mov eax, Mesaj
    call dyaz
    mov eax, edx	; Genel toplam ekrana yazdýrýlacak
    call tyazAS
    call son