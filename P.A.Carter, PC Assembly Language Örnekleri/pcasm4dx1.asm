; pcasm4dx1.asm: Tamsay� verigiri�leri ve toplam�n yazd�r�ld��� altprogram �rne�i.
;
; nasm -fwin32 pcasm4dx1.asm
;----------------------------------------------------------------------------------------------------------------------------------

%include "asm_io.inc"

;; tamsay�_oku altprogram�
;; Y���ndaki s�ras�yla parametreler
;;      girilen say�s� (konumu [ebp + 12])
;;      girilen'in sakland��� adres (konum [ebp + 8])
;; Not: �nceki eax ve ebx de�erleri de�i�ir

	segment .data
    GirdiMesaj� db ") Bir tamsay� de�er girin (Son=0): ", 0

	;;segment .bss
	segment .text
    global tamsay�_oku, toplam�_yaz
tamsay�_oku:
    enter 0, 0
    mov eax, [ebp + 12]
    call yaz_tms
    mov eax, GirdiMesaj�
    call yaz_dizge
    call oku_tms
    mov ebx, [ebp + 8]
    mov [ebx], eax		; Okunan tamsay�y� belle�e sakla
    leave
    ret			; �a��ran anaprograma gerid�n

;; toplam�_yaz altprogram�
;; Parametreler:
;;      yazd�r�lacak toplam (konumu [ebp+8])
;; Not: �nceki eax de�eri kaybolur

	segment .data
    ��kt�Mesaj� db " adet girilen tamsay�n�n toplam� ", 0

	segment .text
toplam�_yaz:
    enter 0, 0
    dec edx
    mov eax, edx
    call yaz_tms
    mov eax, ��kt�Mesaj�
    call yaz_dizge
    mov eax, [ebp+8]
    call yaz_tms
    call yaz_hi�
    leave
    ret