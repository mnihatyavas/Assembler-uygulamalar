; tut16.asm: Ekrana 0,1,2,3,4,5,6,7,8,9 yazma örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; 0123456789
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===DÖNGÜLER===
; 10 kezlik döngü:
; MOV CL, 10
; D1:
; <Döngü-gövdesi>
; DEC CL
; JNZ D1
;
; mov ECX,10
; d1:
; <döngü gövdesi>
; loop d1 ; Loop komutu ECX'i otomatikmen 1 düþürür
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov ecx,10
    mov eax, "0"
d1:
    mov [sayý], eax
    mov eax, 4	; 4=yaz
    mov ebx, 1	; 1=ekran
    push ecx	; ECX yýðýna konulmalý, zira kernel çaðrýldýðýnda içeriðini (aktüel sayý'yý) ekrana yazdýracak
    mov ecx, sayý
    mov edx, 1	; uzunluk=1 byte
    int 0x80

    mov eax, [sayý]
    sub eax, "0"	; ascii'den ondalýða
    inc eax		; eax +=1 ; 0,1,2,3,..9
    add eax, "0"	; ondalýktan ascii'ye
    pop ecx		; yýðýndan ECX alýnýr
    loop d1		; ECX sayaç sýfýr olucaya dek döngüye devam eder

    mov eax,1	; 1=son
    int 0x80

	section .bss
    sayý resb 1