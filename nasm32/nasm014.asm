; nasm014.asm: Ekrandan girilen 2 tamsay�n�n toplam�n� yazd�ran �rnek.
;
; nasm -fwin32 nasm014.asm
; gcc -m32 nasm014.obj -o nasm014.exe
; nasm014
;-----------------------------------------------------------------------------------------------------------

	SECTION .data
    mesaj1: db "�lk tamsay�y� girin: ", 0
    mesaj2: db "�kinci tamsay�y� girin: ", 0
    girdiBi�imi: db "%d", 0
    ��kt�Bi�imi: db "Girilen 2 tamsay�n�n toplam�: %d",  0	; Altsat�r
    tamsay�1: times 4 db 0 ; 32-bits tamsay� = 4 bytes
    tamsay�2: times 4 db 0

	SECTION .text
    global _main
    extern _scanf
    extern _printf

_main:
    push ebx		; Kay�t��lar� y���na koy
    push ecx
    push mesaj1
    call _printf
    add esp, 4		; Y���n g�stergesi son girileni g�rmesin
    push tamsay�1		; Tamsay�1 adresini y���na koy
    push girdiBi�imi		; Girdi bi�imini y���na koy
    call _scanf		; �a��rma y���n� tersten okur
    add esp, 8		; Y���n g�stergesi son 2 girileni g�rmesin
    push mesaj2
    call _printf
    add esp, 4		; Y���n g�stergesi son girileni g�rmesin
    push tamsay�2		; Tamsay�2 adresini y���na koy
    push girdiBi�imi		; Girdi bi�imini y���na koy
    call _scanf		; �a��rma y���n� tersten okur
    add esp, 8		; Y���n g�stergesi son 2 girileni g�rmesin

    mov ebx, dword [tamsay�1]
    mov ecx, dword [tamsay�2]
    add ebx, ecx		; 2 tamsay�y� topla
    push ebx
    push ��kt�Bi�imi
    call _printf		; Toplam sonucu ekrana yans�t
    add esp, 8		; Y���n g�stergesi son 2 girileni g�rmesin
    pop ecx			; Kay�t��lar� y���ndan temizle
    pop ebx
    ;mov eax, 0 ; Hata yok
    ret