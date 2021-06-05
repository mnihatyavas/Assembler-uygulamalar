; tut05.asm: Orijinal ve de�i�tirilen isim'in yazd�r�lmas� �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Ahmet Nihat
; Memet Nihat
;--------------------------------------------------------------------------------------------------------------------------
; ===ADRESLEME K�PLER�===
; komut hedef kaynak
; 3 adresleme kipi: kay�t��, anl�k, bellek
; Kay�t�� adresleme kipi (h�zl�d�r):
; MOV DX, VERG�_ORANI	; Kay�t�� ilk i�lemcide
; MOV SAYA�, CX		; Kay�t�� ikincide
; MOV EAX, EBX		; Kay�t�� herikisinde
;
; Anl�k adresleme kipi:
; BYTE_DE�ER� DB 150	; Bir byte sabiti tan�m�
; KEL�ME_DE�ER� DW 300	; Bir kelime sabiti tan�m�
; ADD BYTE_DE�ER�, 65	; Anl�k 65 ilk de�erli byte sabiti tan�m�
; MOV AX, 45H		; AX kay�t��ya anl�k 65H aktar�lmakta
;
; Direk bellek adresleme:
; ADD BYTE_DE�ER�, DL	; Kay�t��y� bellek konumun ekelr
; MOV BX, KEL�ME_DE�ER� ; Bmaellekten kay�t��ya aktarma
;
; Direk telafi adresleme:
; BYTE_TABLOSU DB 14, 15, 22, 45
; KEL�ME_TABLOSU DW 134, 345, 564, 123
; MOV CL, BYTE_TABLOSU[2]	; 3.byte
; MOV CL, BYTE_TABLOSU + 2	; 3.byte
; MOV CX, KEL�ME_TABLOSU[3]	; 4.kelime
; MOV CX, KEL�ME_TABLOSU + 3	; 4.kelime
;
; Endirek bellek adresleme:
; TABLOM TIMES 10 DW 0	; 0 ilk de�erli 10 kelime
; MOV EBX, [TABLOM]	; TABLOM'un ba�lang�� adresi
; MOV [EBX], 110		; TABLOM[0] = 110
; ADD EBX, 2		; EBX += 2
; MOV [EBX], 123		; TABLOM[1] = 123
;
; MOV hedef, kaynak	; hedef: kay�t��/bellek, kaynak:kay�t��/bellek/anl�k
; Tip belirleyici Byte (1 byte), Word/Kelime (2 byte), Dword/2Kelime (4byte), Qword/4Kelime (8 byte), Tword/5Kelime (10 byte)
;--------------------------------------------------------------------------------------------------------------------------

	section .data
    isim db "Ahmet Nihat"
    uzunluk equ $ - isim

	section .text
    global _start
_start:
; "Ahmett Nihat" isminin yazd�r�lmas�
    mov edx, uzunluk	; mesaj�n uzunlu�u
    mov ecx, isim
    mov ebx,1	; 1=stdout, ekran
    mov eax,4	; 4=sys_write, yaz
    int 0x80		; �a��r

    mov [isim], dword "Memet"	; isim="Memet Nihat" olarak de�i�ti
; de�i�en isim'in yazd�r�lmas�
    mov edx, uzunluk	; mesaj�n uzunlu�u
    mov ecx, isim
    mov ebx,1
    mov eax, 4
    int 0x80

    mov eax,1	; 1=sys_exit, ��k
    int 0x80