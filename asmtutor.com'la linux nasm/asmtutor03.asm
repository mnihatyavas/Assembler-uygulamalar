; asmtutor03.asm: Dizge uzunlu�unu programa hesaplatt�rma �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Selam, (0=ascii30) mesaj uzunlu�unu program�n hesaplad��� d�nya!
;----------------------------------------------------------------------------------------------------------------------------------
; ===3.Dizge Uzunlu�unun Hesab�===
; Dizgede herbir karakter 1 byte olup, ayr�ca sondaki 0xAh'i de 1 byte olarak katmak zorunday�z, yoksa
; nasm s�f�r byte'l� dizge varsayar. CMP kar��la�t�rma ascii 0=null=hi� k�yaslar; ger�er 0=30 ascii'dir.
;----------------------------------------------------------------------------------------------------------------------------------

	SECTION .data
    Mesaj db "Selam, (0=ascii30) mesaj uzunlu�unu program�n hesaplad��� d�nya!", 0Ah

	SECTION .text
    global _start
_start:
    mov ebx, Mesaj	; Mesaj'�n bellek ba�lang�� adresi
    mov eax, ebx

birsonraki_karakter:
    cmp byte [eax], 0	; eax'taki tek byte 0'la kar��la�t�r�l�r
    jz bitti		; E�er ZF=1'se bitti'ye atlan�r (dizge sonu)
    inc eax		; eax bir sonraki byte/krk'i i�aret eder
    jmp birsonraki_karakter	; dizge bitinceye dek d�ng�ye devam edilir

bitti:
    sub eax, ebx	; eax = eax - ebx (dizgenin son adres byte'�ndan ilki ��k�nca uzunluk krk say�s� kal�r)

    mov edx, eax	; edx=uzunluk
    mov ecx, Mesaj	; ecx=Mesaj
    mov ebx, 1	; ebx=1=ekran
    mov eax, 4	; eax=4=yaz
    int 80h

    mov ebx, 0	; ebx=0=hatas�z
    mov eax, 1	; eax=1=��k
    int 80h