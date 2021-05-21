; pcasm4f.asm: 1'den n'e tamsay�lar�n toplam�n� hesaplama �rne�i.
;
; nasm -fwin32 pcasm4f.asm
; gcc -m32 pcasm4f.c asm_io.obj pcasm4f.obj
; a
;--------------------------------------------------------------------------------------------------------------------------------
; Altprogramda hesaplanan toplam ayr� bir *tplp de�i�keniyle void fonksiyon parametresi olarak ge�irilmek
; yerine [int toplam_hesapla (int)] tipli fonksiyona return toplam'la daha pratik d�nd�r�lebilir.
;--------------------------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"

;; _toplam�_hesapla altprogram�
;; 1'den n'e tamsay�lar� toplar
;; Parametreler:
;;    n    -toplam� bulunacak �st limit (konumu [ebp + 8])
;; sanal C kodu:
;; int toplam�_hesapla (int n) {
;;    int i, toplam = 0;
;;    for (i=1; i <= n; i++) toplam += i;
;;    return toplam;
;; } // top..sonu...

	segment .text
    global _toplam_hesapla
;;
;; yerel de�i�ken:
;;    toplam (konumu [ebp-4])
_toplam_hesapla:
    enter 4, 0		; Y���nda toplam i�in yer tahsisi
    mov dword [ebp-4], 0	; toplam = 0
    mov ecx, 1		; sanal i
for_d�ng�s�:
    cmp ecx, [ebp+8]		; cmp i, n
    jnle for_sonu		; if not i <= n, ��k
    add [ebp-4], ecx		; toplam += i
    inc ecx
    jmp short for_d�ng�s�
for_sonu:
    mov eax, [ebp-4]		; eax = toplam
    leave
    ret