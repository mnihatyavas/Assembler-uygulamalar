; pcasm4dx1.asm: Tamsayý verigiriþleri ve toplamýn yazdýrýldýðý altprogram örneði.
;
; nasm -fwin32 pcasm4dx1.asm
;----------------------------------------------------------------------------------------------------------------------------------

%include "asm_io.inc"

;; tamsayý_oku altprogramý
;; Yýðýndaki sýrasýyla parametreler
;;      girilen sayýsý (konumu [ebp + 12])
;;      girilen'in saklandýðý adres (konum [ebp + 8])
;; Not: önceki eax ve ebx deðerleri deðiþir

	segment .data
    GirdiMesajý db ") Bir tamsayý deðer girin (Son=0): ", 0

	;;segment .bss
	segment .text
    global tamsayý_oku, toplamý_yaz
tamsayý_oku:
    enter 0, 0
    mov eax, [ebp + 12]
    call yaz_tms
    mov eax, GirdiMesajý
    call yaz_dizge
    call oku_tms
    mov ebx, [ebp + 8]
    mov [ebx], eax		; Okunan tamsayýyý belleðe sakla
    leave
    ret			; Çaðýran anaprograma geridön

;; toplamý_yaz altprogramý
;; Parametreler:
;;      yazdýrýlacak toplam (konumu [ebp+8])
;; Not: önceki eax deðeri kaybolur

	segment .data
    ÇýktýMesajý db " adet girilen tamsayýnýn toplamý ", 0

	segment .text
toplamý_yaz:
    enter 0, 0
    dec edx
    mov eax, edx
    call yaz_tms
    mov eax, ÇýktýMesajý
    call yaz_dizge
    mov eax, [ebp+8]
    call yaz_tms
    call yaz_hiç
    leave
    ret