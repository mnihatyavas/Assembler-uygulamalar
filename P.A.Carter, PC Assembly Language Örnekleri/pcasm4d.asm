; pcasm4d.asm: Girilen tamsayýlarýn toplamýnýn hesaplandýðý ASM çaðýran program örneði.
;
; nasm -fwin32 pcasm4d.asm
; gcc -m32 pcasm4d.obj pcasm4dx1.obj pcasm.c asm_io.obj
; a
;-----------------------------------------------------------------------------------------------------------------------------------------------
; Altprogramlarda yýðýndaki veriler yerel deðerler, hafýzadakiler ise global/static deðiþkenler olarak düþünülebilir.
; Altprogramlarlar yýðýn verilerle recursive/kendini çaðýran olarak da kullanýlabilir.
;
;; altprogram_etiketi:
;; push ebp	; orijinal EBP deðeri yýðýna sokulur
;; mov ebp, esp	; yeni EBP = ESP
;; sub esp, LOCAL_BYTES	; yereller tarafýndan gereksinilen byte sayýsý
;; 	; diðer altprogram kodlamalarý
;; mov esp, ebp	; yerel deðiþken tahsis sonu
;; pop ebp		; orijinal EBP deðerinin alýnmasý
;; ret
;
;; void toplamý_hesapla (int n, int *tpl ) {// 1'den n'e kadar sýralý toplamý hesaplayan C kodlamasý
;;      int i , toplam = 0;
;;      for (i=1; i <= n; i++ ) toplam += i;
;;      *tpl = toplam;
;; } // func sonu...
;
;; toplamý_hesapla:	; Yukardaki C'nin ASM kodlamasý
;;      push ebp
;;      mov ebp, esp
;;      sub esp, 4	; Yerel toplam için yýðýnda yer aç
;;      mov dword [ebp - 4], 0	; toplam = 0
;;      mov ebx, 1		; ebx (i) = 1
;; for_döngüsü:
;;      cmp ebx, [ebp+8]		; i <= n?
;;      jnle for_sonu
;;      add [ebp-4], ebx	; toplam += i
;;      inc ebx
;;      jmp short for_döngüsü
;; for_sonu:
;;      mov ebx, [ebp+12]	; ebx = tpl
;;      mov eax, [ebp-4]	; eax = toplam
;;      mov [ebx], eax		; *tpl = toplam;
;;      mov esp, ebp
;;      pop ebp
;;      ret
;
; extern tanýmý bu programda kullanýlacak olan, diðer programlarda tanýmlý etiket (altprogram) adlarýdýr.
; asm_io.inc include/dahili altprogram tüm pcasmx.asm modüllerde kullanýlacak olan oku/yaz altprogramlarý
; extern olarak tanýmlar. Bu altprogramlar da asm_io.asm içinde global tanýmlanýp, hazýr C printf, scanf
; altprogramlarýný kullanýr. Bu modüller birlikte gcc ile exe'ye dönüþtüðünde üstteki oku/yaz, alttaki C kütüphanesi
; printf/scanf kodlamasýyla buluþup sonucu gerçekleþtiren baðýmsýz exe'leri üretirler.
;-----------------------------------------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"

	segment .data
    toplam dd 0

	segment .bss
    girilen resd 1

;; // C kodlamasý
;; i = 1;
;; toplam = 0;
;; while (tamsayý_oku (i, &girilen), girilen != 0 ) {
;;      toplam += girilen;
;;      i++;
;; } // while sonu
;; toplamý_yaz (toplam);

	segment .text
    global  _esas_kodlama
    extern  tamsayý_oku, toplamý_yaz
_esas_kodlama:
    enter 0, 0	; baþlatma rutini
    pusha

    mov edx, 1	; i = edx = 1
while_döngüsü:
    push edx	; i yýðýna saklanýr
    push dword girilen		; girilen deðiþken adresi yýðýna saklanýr
    call tamsayý_oku		; harici/extern altprogramdan girilen okunur
    add esp, 8		; pop/add ile yýðýndan i ve &girilen çýkarýlýr
    mov eax, [girilen]
    cmp eax, 0
    je while_sonu		; girilen=0 ise döngüden çýkýlýr
    add [toplam], eax		; toplam += girilen
    inc edx			; i += 1
    jmp short while_döngüsü
while_sonu:
    push dword [toplam]	; toplam deðeri yýðýna sokulur
    call toplamý_yaz		; toplamý yazdýrma harici/extern altprogram çaðrýlýr
    pop ecx			; [toplam] yýðýndan silinir

    popa		; sonlandýrma rutini
    leave
    ret