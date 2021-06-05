; tut05.asm: Orijinal ve deðiþtirilen isim'in yazdýrýlmasý örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Ahmet Nihat
; Memet Nihat
;--------------------------------------------------------------------------------------------------------------------------
; ===ADRESLEME KÝPLERÝ===
; komut hedef kaynak
; 3 adresleme kipi: kayýtçý, anlýk, bellek
; Kayýtçý adresleme kipi (hýzlýdýr):
; MOV DX, VERGÝ_ORANI	; Kayýtçý ilk iþlemcide
; MOV SAYAÇ, CX		; Kayýtçý ikincide
; MOV EAX, EBX		; Kayýtçý herikisinde
;
; Anlýk adresleme kipi:
; BYTE_DEÐERÝ DB 150	; Bir byte sabiti tanýmý
; KELÝME_DEÐERÝ DW 300	; Bir kelime sabiti tanýmý
; ADD BYTE_DEÐERÝ, 65	; Anlýk 65 ilk deðerli byte sabiti tanýmý
; MOV AX, 45H		; AX kayýtçýya anlýk 65H aktarýlmakta
;
; Direk bellek adresleme:
; ADD BYTE_DEÐERÝ, DL	; Kayýtçýyý bellek konumun ekelr
; MOV BX, KELÝME_DEÐERÝ ; Bmaellekten kayýtçýya aktarma
;
; Direk telafi adresleme:
; BYTE_TABLOSU DB 14, 15, 22, 45
; KELÝME_TABLOSU DW 134, 345, 564, 123
; MOV CL, BYTE_TABLOSU[2]	; 3.byte
; MOV CL, BYTE_TABLOSU + 2	; 3.byte
; MOV CX, KELÝME_TABLOSU[3]	; 4.kelime
; MOV CX, KELÝME_TABLOSU + 3	; 4.kelime
;
; Endirek bellek adresleme:
; TABLOM TIMES 10 DW 0	; 0 ilk deðerli 10 kelime
; MOV EBX, [TABLOM]	; TABLOM'un baþlangýç adresi
; MOV [EBX], 110		; TABLOM[0] = 110
; ADD EBX, 2		; EBX += 2
; MOV [EBX], 123		; TABLOM[1] = 123
;
; MOV hedef, kaynak	; hedef: kayýtçý/bellek, kaynak:kayýtçý/bellek/anlýk
; Tip belirleyici Byte (1 byte), Word/Kelime (2 byte), Dword/2Kelime (4byte), Qword/4Kelime (8 byte), Tword/5Kelime (10 byte)
;--------------------------------------------------------------------------------------------------------------------------

	section .data
    isim db "Ahmet Nihat"
    uzunluk equ $ - isim

	section .text
    global _start
_start:
; "Ahmett Nihat" isminin yazdýrýlmasý
    mov edx, uzunluk	; mesajýn uzunluðu
    mov ecx, isim
    mov ebx,1	; 1=stdout, ekran
    mov eax,4	; 4=sys_write, yaz
    int 0x80		; çaðýr

    mov [isim], dword "Memet"	; isim="Memet Nihat" olarak deðiþti
; deðiþen isim'in yazdýrýlmasý
    mov edx, uzunluk	; mesajýn uzunluðu
    mov ecx, isim
    mov ebx,1
    mov eax, 4
    int 0x80

    mov eax,1	; 1=sys_exit, çýk
    int 0x80