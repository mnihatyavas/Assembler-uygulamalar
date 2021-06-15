; asmtutor04.asm: Yazdýrýlacak mesaj uzunluðunun altrutinde hesaplanmasý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Altrutinli assembler dünyasýna merhaba!
;----------------------------------------------------------------------------------------------------------------------------------
; ===4.Altrutinler===
; Altrutinler _start: etiketadlarý gibidir, ancak etiketadlarýna gidiþ-dönüþ JMP ile yapýlýrken, altrutinlere gidiþ
; CALL, dönüþse RET iledir. Altrutinden dönüþte kaybolmasýný/deðiþmesini istemediðiniz bilgileri PUSH ile
; yýðýna koyar, dönüþte de POP ile tekrar alýrsýnýz. CALL ve RET gerçekte altrutine akýþ giderken dönüþ
; adresinin yýðýn'a saklanmasý ve alýnmasýdýr. JMP'ta ise otomatik yýðýn kullanýmý yoktur.
;----------------------------------------------------------------------------------------------------------------------------------

	SECTION .data
    Mesaj db "Altrutinli assembler dünyasýna merhaba!", 0Ah

	SECTION .text
    global _start
_start:
    mov eax, Mesaj	; Mesaj dizge adresi EAX'a taþýnýr
    call dizge_uzunluðu	; Mesaj dizgesinin uzunluðunu hesaplayan altrutinin çaðrýlmasý
    mov edx, eax	; Bulunan ve EAX'a konulan uzunluk deðeri EDX'e taþýnýr
    mov ecx, Mesaj	; Yazdýrýlacak Mesaj ECX'e taþýnýr
    mov ebx, 1	; EBX=1=Ekran
    mov eax, 4	; EAX=4=Yaz
    int 80h		; Kernel'i çaðýr

    mov ebx, 0	; 0=Hatasýz sonlanýþ
    mov eax, 1	; 1=Çýk
    int 80h

dizge_uzunluðu:	; Çaðrýlan altrutin/fonksiyon adý
    push ebx	; EBX deðerini yýðýna koy
    mov ebx, eax	; Mesaj adresli EAX'I EBX'e taþý
birsonraki_karakter:
    cmp byte [eax], 0	; Aktüel EAX byte karakteri ascii 0/null mu?
    jz tamamlandý	; 0 ise etikete atla
    inc eax		; Bir sonraki Mesaj byte/karakter adresine artýr
    jmp birsonraki_karakter
tamamlandý:
    sub eax, ebx	; EAX -=EBX ; Mesaj uzunluðu
    pop ebx	; Yýðýna saklanan orijinal EBX'i al
    ret		; Çaðrýlan adrese geridön