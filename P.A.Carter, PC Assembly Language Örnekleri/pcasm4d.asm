; pcasm4d.asm: Girilen tamsay�lar�n toplam�n�n hesapland��� ASM �a��ran program �rne�i.
;
; nasm -fwin32 pcasm4d.asm
; gcc -m32 pcasm4d.obj pcasm4dx1.obj pcasm.c asm_io.obj
; a
;-----------------------------------------------------------------------------------------------------------------------------------------------
; Altprogramlarda y���ndaki veriler yerel de�erler, haf�zadakiler ise global/static de�i�kenler olarak d���n�lebilir.
; Altprogramlarlar y���n verilerle recursive/kendini �a��ran olarak da kullan�labilir.
;
;; altprogram_etiketi:
;; push ebp	; orijinal EBP de�eri y���na sokulur
;; mov ebp, esp	; yeni EBP = ESP
;; sub esp, LOCAL_BYTES	; yereller taraf�ndan gereksinilen byte say�s�
;; 	; di�er altprogram kodlamalar�
;; mov esp, ebp	; yerel de�i�ken tahsis sonu
;; pop ebp		; orijinal EBP de�erinin al�nmas�
;; ret
;
;; void toplam�_hesapla (int n, int *tpl ) {// 1'den n'e kadar s�ral� toplam� hesaplayan C kodlamas�
;;      int i , toplam = 0;
;;      for (i=1; i <= n; i++ ) toplam += i;
;;      *tpl = toplam;
;; } // func sonu...
;
;; toplam�_hesapla:	; Yukardaki C'nin ASM kodlamas�
;;      push ebp
;;      mov ebp, esp
;;      sub esp, 4	; Yerel toplam i�in y���nda yer a�
;;      mov dword [ebp - 4], 0	; toplam = 0
;;      mov ebx, 1		; ebx (i) = 1
;; for_d�ng�s�:
;;      cmp ebx, [ebp+8]		; i <= n?
;;      jnle for_sonu
;;      add [ebp-4], ebx	; toplam += i
;;      inc ebx
;;      jmp short for_d�ng�s�
;; for_sonu:
;;      mov ebx, [ebp+12]	; ebx = tpl
;;      mov eax, [ebp-4]	; eax = toplam
;;      mov [ebx], eax		; *tpl = toplam;
;;      mov esp, ebp
;;      pop ebp
;;      ret
;
; extern tan�m� bu programda kullan�lacak olan, di�er programlarda tan�ml� etiket (altprogram) adlar�d�r.
; asm_io.inc include/dahili altprogram t�m pcasmx.asm mod�llerde kullan�lacak olan oku/yaz altprogramlar�
; extern olarak tan�mlar. Bu altprogramlar da asm_io.asm i�inde global tan�mlan�p, haz�r C printf, scanf
; altprogramlar�n� kullan�r. Bu mod�ller birlikte gcc ile exe'ye d�n��t���nde �stteki oku/yaz, alttaki C k�t�phanesi
; printf/scanf kodlamas�yla bulu�up sonucu ger�ekle�tiren ba��ms�z exe'leri �retirler.
;-----------------------------------------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"

	segment .data
    toplam dd 0

	segment .bss
    girilen resd 1

;; // C kodlamas�
;; i = 1;
;; toplam = 0;
;; while (tamsay�_oku (i, &girilen), girilen != 0 ) {
;;      toplam += girilen;
;;      i++;
;; } // while sonu
;; toplam�_yaz (toplam);

	segment .text
    global  _esas_kodlama
    extern  tamsay�_oku, toplam�_yaz
_esas_kodlama:
    enter 0, 0	; ba�latma rutini
    pusha

    mov edx, 1	; i = edx = 1
while_d�ng�s�:
    push edx	; i y���na saklan�r
    push dword girilen		; girilen de�i�ken adresi y���na saklan�r
    call tamsay�_oku		; harici/extern altprogramdan girilen okunur
    add esp, 8		; pop/add ile y���ndan i ve &girilen ��kar�l�r
    mov eax, [girilen]
    cmp eax, 0
    je while_sonu		; girilen=0 ise d�ng�den ��k�l�r
    add [toplam], eax		; toplam += girilen
    inc edx			; i += 1
    jmp short while_d�ng�s�
while_sonu:
    push dword [toplam]	; toplam de�eri y���na sokulur
    call toplam�_yaz		; toplam� yazd�rma harici/extern altprogram �a�r�l�r
    pop ecx			; [toplam] y���ndan silinir

    popa		; sonland�rma rutini
    leave
    ret