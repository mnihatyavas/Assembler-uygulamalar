; pcasm4c.asm: Girilen çoklu tamsayýlarýn toplamýný sunan altprogramlar örneði.
;
; nasm -fwin32 pcasm4c.asm
; gcc -m32 pcasm4c.obj pcasm.c asm_io.obj (-o pcasm4c.exe)
;----------------------------------------------------------------------------------------------------------------------------------------------
;
; Genel kabul, altprograma CALL ile girilmesi ve RET ile dönülmesidir.
; Parametreler CALL öncesi yýðýna sokulur, altprogramda deðerleri deðiþtirilecekse yýðýndaki adresleri
; kullanýlýr, deðerleri deðil. Deðerler dword'den farklýysa yýðýna sokulmadan önce dword'e çevrilir.
;----------------------------------------------------------------------------------------------------------------------------------------------

    %include "asm_io.inc"

	segment .data
    toplam dd 0

	segment .bss
    tamsayý resd 1

; // C kodlamasý
; i = 1;
; toplam = 0;
; while (get_int (i, &n), n != 0 ) {
;     toplam += n;
;     i++;
; } // while sonu...
; print (toplam);

	segment .text
    global  _esas_kodlama
_esas_kodlama:
    enter 0, 0
    pusha

    mov edx, 1		; edx = i karþýlýðýdýr
döngü:
    push edx		; i yýðýna saklanýr
    push dword tamsayý	; tamsayý deðiþken adresi yýðýna saklanýr
    call tamsayý_oku
    add esp, 8		; i ve &tamsayý yýðýndan silinir
    mov eax, [tamsayý]
    cmp eax, 0
    je döngü_sonu
    add [toplam], eax		; toplam += tamsayý
    inc edx
    jmp short döngü
döngü_sonu:
    push dword [toplam]	; toplam deðer yýðýna sokulur
    call toplamý_yaz
    pop ecx			;  [toplam] yýðýndan silinir

    popa
    leave
    ret

; Altprogram: tamsayý_oku
; Yýðýndaki parametreler
;       tamsayý adedi, i (konumu [ebp + 12])
;       tamsayý'nýn adresi (konumu [ebp + 8])

	segment .data
VerigiriþMesajý db ") Bir tamsayý girin (Çýkýþ: 0): ", 0

	segment .text
tamsayý_oku:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 12]
    call yaz_tms
    mov eax, VerigiriþMesajý
    call yaz_dizge
    call oku_tms
    mov ebx, [ebp + 8]
    mov [ebx], eax
    pop ebp
    ret

; Altprogram: toplamý_yaz
; Parametreler:
;       yazdýrýlacak toplam (konumu [ebp+8])

	segment .data
ÇýktýMesajý db " adet girilen tamsayýlarýn toplamý: ", 0

	segment .text
toplamý_yaz:
    push ebp
    mov ebp, esp
    dec edx
    mov eax, edx
    call yaz_tms
    mov eax, ÇýktýMesajý
    call yaz_dizge
    mov eax, [ebp+8]
    call yaz_tms
    call yaz_hiç
    pop ebp
    ret