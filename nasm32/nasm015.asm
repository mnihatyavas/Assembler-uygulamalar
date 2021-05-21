; nasm05.asm: Komut sat�r�ndan girilen 2 tamsay�n�n toplam�n� yans�tma �rne�i.
;
; nasm -fwin31 nasm015.asm
; gcc -m32 nasm015.obj -o nasm015.exe
; nasm015 24 76
;---------------------------------------------------------------------------------------------------------------------

	SECTION .data
    ��kt�Bi�imi: db "Komutsat�r�ndan girilen 2 +tamsay�n�n toplam�: %d", 0	; Altsat�r 0 sonland�r�c�

	SECTION .text
    global _main
    extern _printf

karakterdenTamsay�ya:	; Komut sat�r�ndan yap�lan karakter giri�ini tamsay�ya �eviriyoruz
    push ebx	; Kay�t�� adresleini y���na koy
    push ecx
    mov ebx, eax	; Komut sat�r�ndan girilen arg�man eax'da farzediyoruz
    mov eax, 0

d�ng�:
    cmp byte [ebx], 0
    je tamamland�
    mov ecx, 10
    mul ecx		; �oklu rakam giri�inde �nceki hane-ler 10'la �arp�l�p sonrakilerle toplanacak
    mov cl, byte [ebx]
    sub cl, "0"
    add eax, ecx
    inc ebx
    jmp d�ng�

tamamland�:
    pop ecx		; Y���n bo�alt�ls�n
    pop ebx
    ret		; �a�r�lan adrese geri d�n��

_main:
    push ebp
    mov ebp, esp
    push ebx	; Kay�t��lar y���na saklans�n
    push ecx
    cmp dword [ebp+8], 3	; Arg�man say�s� 3 de�ilse i�lem yap�lmas�n
    jne main_sonu
    mov ebx, [ebp+12]	; Arg�manlar temel kay�t��ya
    mov eax, [ebx+4]		; �lk tamsay� toplay�c� kay�t��ya
    call karakterdenTamsay�ya	; �lk arg�man karakterden tamsay�ya �evrilsin
    mov ecx, eax		; Y���n bo�alt�ls�n
    mov eax, [ebx+8]		; �kinci tamsay� toplay�c�ya
    call karakterdenTamsay�ya	; 2.arg�man tamsay�ya �evrilsin
    add eax, ecx		; Her iki tamsay� toplans�n
    push eax
    push ��kt�Bi�imi
    call _printf		; Sonu� ekrana yazd�r�ls�n
    add esp, 8		; Y���n parametreleri silinsin

main_sonu:
    pop ecx			; Kay�t�� ve g�sterge gerid�n�� adresleri y���ndan al�ns�n
    pop ebx
    pop ebp
    mov eax, 0		; Hata g�sterme
    ret