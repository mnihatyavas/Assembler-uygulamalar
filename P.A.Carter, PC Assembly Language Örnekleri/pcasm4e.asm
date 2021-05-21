; pcasm4e.asm: 1'den n'e tamsayýlarýn toplamýný hesaplama örneði.
;
; nasm -fwin32 pcasm4e.asm
; gcc -m32 pcasm4e.c asm_io.obj pcasm4e.obj
; a
;--------------------------------------------------------------------------------------------------------------------------------
;
;;	segment .data
;;    x dd 0
;;    Biçimleme db "x = %d\n", 0
;;
;;	segment .text
;;    push dword [x]		; x'in deðerini yýðýna koy
;;    push dword Biçimleme	; Biçimleme dizgesinin adresini yýðýna koy
;;    call _printf		; extern C fonksiyonu
;;    add esp, 8		; Parametreleri yýðýndan sil
;

    %include "asm_io.inc"

;; _toplamý_hesapla altprogramý
;; 1'den n'e tamsayýlarý toplar
;; Parametreler:
;;    n    -toplamý bulunacak üst limit (konumu [ebp + 8])
;;    tplp - toplamýn depolanacaðý göstergeç (konumu [ebp + 12])
;; sanal C kodu:
;; void toplamý_hesapla (int n, int *tplp) {
;;    int i, toplam = 0;
;;    for (i=1; i <= n; i++) toplam += i;
;;    *tplp = toplam;
;; } // top..sonu...

	segment .text
    global _toplam_hesapla
;;
;; yerel deðiþken:
;;    toplam (konumu [ebp-4])
_toplam_hesapla:
    enter 4, 0		; Yýðýnda toplam için yer tahsisi
    push ebx

    mov dword [ebp-4], 0	; toplam = 0
    yýðýný_boþalt 1, 2, 4	; Yýðýndan ebp-8 --> ebp+16 arasýný yazdýr
    mov ecx, 1		; sanal i
for_döngüsü:
    cmp ecx, [ebp+8]		; cmp i, n
    jnle for_sonu		; if not i <= n, çýk
    add [ebp-4], ecx		; toplam += i
    inc ecx
    jmp short for_döngüsü
for_sonu:
    mov ebx, [ebp+12]	; ebx = tplp
    mov eax, [ebp-4]		; eax = toplam
    mov [ebx], eax

    pop ebx		; Yýðýndan ebx'i al
    leave
    ret