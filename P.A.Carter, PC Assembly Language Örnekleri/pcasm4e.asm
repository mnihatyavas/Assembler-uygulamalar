; pcasm4e.asm: 1'den n'e tamsay�lar�n toplam�n� hesaplama �rne�i.
;
; nasm -fwin32 pcasm4e.asm
; gcc -m32 pcasm4e.c asm_io.obj pcasm4e.obj
; a
;--------------------------------------------------------------------------------------------------------------------------------
;
;;	segment .data
;;    x dd 0
;;    Bi�imleme db "x = %d\n", 0
;;
;;	segment .text
;;    push dword [x]		; x'in de�erini y���na koy
;;    push dword Bi�imleme	; Bi�imleme dizgesinin adresini y���na koy
;;    call _printf		; extern C fonksiyonu
;;    add esp, 8		; Parametreleri y���ndan sil
;

    %include "asm_io.inc"

;; _toplam�_hesapla altprogram�
;; 1'den n'e tamsay�lar� toplar
;; Parametreler:
;;    n    -toplam� bulunacak �st limit (konumu [ebp + 8])
;;    tplp - toplam�n depolanaca�� g�sterge� (konumu [ebp + 12])
;; sanal C kodu:
;; void toplam�_hesapla (int n, int *tplp) {
;;    int i, toplam = 0;
;;    for (i=1; i <= n; i++) toplam += i;
;;    *tplp = toplam;
;; } // top..sonu...

	segment .text
    global _toplam_hesapla
;;
;; yerel de�i�ken:
;;    toplam (konumu [ebp-4])
_toplam_hesapla:
    enter 4, 0		; Y���nda toplam i�in yer tahsisi
    push ebx

    mov dword [ebp-4], 0	; toplam = 0
    y���n�_bo�alt 1, 2, 4	; Y���ndan ebp-8 --> ebp+16 aras�n� yazd�r
    mov ecx, 1		; sanal i
for_d�ng�s�:
    cmp ecx, [ebp+8]		; cmp i, n
    jnle for_sonu		; if not i <= n, ��k
    add [ebp-4], ecx		; toplam += i
    inc ecx
    jmp short for_d�ng�s�
for_sonu:
    mov ebx, [ebp+12]	; ebx = tplp
    mov eax, [ebp-4]		; eax = toplam
    mov [ebx], eax

    pop ebx		; Y���ndan ebx'i al
    leave
    ret