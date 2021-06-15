; asmtutor05.asm: S�k kullan�lan altrutinlerin haricidosyas�n� anaprograma dahiletme �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Altrutinleri i�eren harici dosya d�nyass�na merhaba!

; INCLUDE anahtarkelimesiyleanaprograma dahil edilir.
; 
INCLUDE anahtarkelimesiyleanaprograma dahil edilir.
;----------------------------------------------------------------------------------------------------------------------------------
; ===5.Harici INCLUDE dosyalar�===
; Farkl� programlarda kullan�lacak altrutinler ayr� dosya olarak saklanarak, kullan�lacak programa INCLUDE
; anahtarkelimeyle dahil edilip, ayn� programdaym��cas�na �a�r�labilmektedir.
; Mesaj1 yaz�l�rken, dizge sonunda ascii 0/null g�rnedi�inden Mesaj2'yi de yazar. Sonradan Mesaj2 tekrar
; yaz�l�nca ortaya istenmeyen fazlal�k ��kar.
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor5x.asm"	; Genel altrutinleri kapsayan harici dosya

	SECTION .data
    Mesaj1 db "Altrutinleri i�eren harici dosya d�nyass�na merhaba!", 0Ah
    Mesaj2 db "INCLUDE anahtarkelimesiyleanaprograma dahil edilir.", 0Ah

	SECTION .text
    global _start
_start:
    mov eax, Mesaj1	; Mesaj1 adresi EAX'a ta��n�r
    call dyaz	; Mesaj1 ekrana yazd�r�l�r
    mov eax, Mesaj2	; Mesaj2 adresi EAX'a ta��n�r
    call dyaz	; Mesaj2 ekrana yazd�r�l�r
    call son		; Program hatas�z sonland�r�l�r