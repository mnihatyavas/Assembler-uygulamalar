; asmtutor04.asm: Yazd�r�lacak mesaj uzunlu�unun altrutinde hesaplanmas� �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Altrutinli assembler d�nyas�na merhaba!
;----------------------------------------------------------------------------------------------------------------------------------
; ===4.Altrutinler===
; Altrutinler _start: etiketadlar� gibidir, ancak etiketadlar�na gidi�-d�n�� JMP ile yap�l�rken, altrutinlere gidi�
; CALL, d�n��se RET iledir. Altrutinden d�n��te kaybolmas�n�/de�i�mesini istemedi�iniz bilgileri PUSH ile
; y���na koyar, d�n��te de POP ile tekrar al�rs�n�z. CALL ve RET ger�ekte altrutine ak�� giderken d�n��
; adresinin y���n'a saklanmas� ve al�nmas�d�r. JMP'ta ise otomatik y���n kullan�m� yoktur.
;----------------------------------------------------------------------------------------------------------------------------------

	SECTION .data
    Mesaj db "Altrutinli assembler d�nyas�na merhaba!", 0Ah

	SECTION .text
    global _start
_start:
    mov eax, Mesaj	; Mesaj dizge adresi EAX'a ta��n�r
    call dizge_uzunlu�u	; Mesaj dizgesinin uzunlu�unu hesaplayan altrutinin �a�r�lmas�
    mov edx, eax	; Bulunan ve EAX'a konulan uzunluk de�eri EDX'e ta��n�r
    mov ecx, Mesaj	; Yazd�r�lacak Mesaj ECX'e ta��n�r
    mov ebx, 1	; EBX=1=Ekran
    mov eax, 4	; EAX=4=Yaz
    int 80h		; Kernel'i �a��r

    mov ebx, 0	; 0=Hatas�z sonlan��
    mov eax, 1	; 1=��k
    int 80h

dizge_uzunlu�u:	; �a�r�lan altrutin/fonksiyon ad�
    push ebx	; EBX de�erini y���na koy
    mov ebx, eax	; Mesaj adresli EAX'I EBX'e ta��
birsonraki_karakter:
    cmp byte [eax], 0	; Akt�el EAX byte karakteri ascii 0/null mu?
    jz tamamland�	; 0 ise etikete atla
    inc eax		; Bir sonraki Mesaj byte/karakter adresine art�r
    jmp birsonraki_karakter
tamamland�:
    sub eax, ebx	; EAX -=EBX ; Mesaj uzunlu�u
    pop ebx	; Y���na saklanan orijinal EBX'i al
    ret		; �a�r�lan adrese gerid�n