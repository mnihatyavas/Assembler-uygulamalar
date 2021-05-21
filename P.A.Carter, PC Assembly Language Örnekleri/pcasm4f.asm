; pcasm4f.asm: 1'den n'e tamsayýlarýn toplamýný hesaplama örneði.
;
; nasm -fwin32 pcasm4f.asm
; gcc -m32 pcasm4f.c asm_io.obj pcasm4f.obj
; a
;--------------------------------------------------------------------------------------------------------------------------------
; Altprogramda hesaplanan toplam ayrý bir *tplp deðiþkeniyle void fonksiyon parametresi olarak geçirilmek
; yerine [int toplam_hesapla (int)] tipli fonksiyona return toplam'la daha pratik döndürülebilir.
;--------------------------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"

;; _toplamý_hesapla altprogramý
;; 1'den n'e tamsayýlarý toplar
;; Parametreler:
;;    n    -toplamý bulunacak üst limit (konumu [ebp + 8])
;; sanal C kodu:
;; int toplamý_hesapla (int n) {
;;    int i, toplam = 0;
;;    for (i=1; i <= n; i++) toplam += i;
;;    return toplam;
;; } // top..sonu...

	segment .text
    global _toplam_hesapla
;;
;; yerel deðiþken:
;;    toplam (konumu [ebp-4])
_toplam_hesapla:
    enter 4, 0		; Yýðýnda toplam için yer tahsisi
    mov dword [ebp-4], 0	; toplam = 0
    mov ecx, 1		; sanal i
for_döngüsü:
    cmp ecx, [ebp+8]		; cmp i, n
    jnle for_sonu		; if not i <= n, çýk
    add [ebp-4], ecx		; toplam += i
    inc ecx
    jmp short for_döngüsü
for_sonu:
    mov eax, [ebp-4]		; eax = toplam
    leave
    ret