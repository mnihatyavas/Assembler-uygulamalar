; asmtutor05.asm: Sýk kullanýlan altrutinlerin haricidosyasýný anaprograma dahiletme örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Altrutinleri içeren harici dosya dünyassýna merhaba!

; INCLUDE anahtarkelimesiyleanaprograma dahil edilir.
; 
INCLUDE anahtarkelimesiyleanaprograma dahil edilir.
;----------------------------------------------------------------------------------------------------------------------------------
; ===5.Harici INCLUDE dosyalarý===
; Farklý programlarda kullanýlacak altrutinler ayrý dosya olarak saklanarak, kullanýlacak programa INCLUDE
; anahtarkelimeyle dahil edilip, ayný programdaymýþcasýna çaðrýlabilmektedir.
; Mesaj1 yazýlýrken, dizge sonunda ascii 0/null görnediðinden Mesaj2'yi de yazar. Sonradan Mesaj2 tekrar
; yazýlýnca ortaya istenmeyen fazlalýk çýkar.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor5x.asm"	; Genel altrutinleri kapsayan harici dosya

	SECTION .data
    Mesaj1 db "Altrutinleri içeren harici dosya dünyassýna merhaba!", 0Ah
    Mesaj2 db "INCLUDE anahtarkelimesiyleanaprograma dahil edilir.", 0Ah

	SECTION .text
    global _start
_start:
    mov eax, Mesaj1	; Mesaj1 adresi EAX'a taþýnýr
    call dyaz	; Mesaj1 ekrana yazdýrýlýr
    mov eax, Mesaj2	; Mesaj2 adresi EAX'a taþýnýr
    call dyaz	; Mesaj2 ekrana yazdýrýlýr
    call son		; Program hatasýz sonlandýrýlýr