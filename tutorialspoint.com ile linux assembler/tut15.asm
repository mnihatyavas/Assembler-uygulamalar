; tut15.asm: Kodlamal� �� say�dan enb���n�n bulunmas� �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; �� say�n�n enb�y���: 47
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===�ARTLAR===
; �artlar �arts�z JMP/Jump/Atla yada �artl� J<�art> komutuyla ak��� d�ng� veya dallanma etiketine y�nUzunlukdirir.
; CMP/Compare/K�yasla hedef, kaynak ; sonucunu kritik ederek atlama yapabilir.
; CMP DX, 00
; JE L7 ; E�itse L7 etiketine atla
; ...
; L7: ...
; 
; D�NG�1:
; INC EDX
; CMP EDX 10
; JLE D�NG�1 ; 10 kez d�ner
; ...
;
; MOV AX, 00
; MOV BX, 00
; MOV CX, 01
; L20:
; ADD AX, 01 , yada INC AX
; ADD BX, AX ; BX += AX ; 1+2+3+...
; SHL CX, 1 ; ShiftLeft/SolaKay, de�er katlan�r ; 1, 2, 4, 8...
; JMP L20 ; d�ng�ye devam
;
; ��aretli veri atlamalar�:
; JE/JZ ; JumpEqual/JumpZero, ZF
; JNE/JNZ ; JumpNotEqual/JumpNotZero, ZF
; JG/JNLE ; JumpGreater/JumpNotLessEqual ; OF, SF, ZF
; JGE/JNL ; JumpGreaterEqual/JumpNotLess ; OF, SF
; JL/JNGE ; Jump Less/JumpNotGreaterEqual ; OF, SF
; JLE/JNG ; JumpLessEqual/JumpNotGreater ; OF, SF, ZF
;
; ��aretsiz veri atlamalar�:
; JE/JZ ; Jump Equal/JumpZero, ZF
; JNE/JNZ ; JumpNotEqual/JumpNotZero, ZF
; JA/JNBE ; JumpAbove/JumpNotBelowEqual ; CF, ZF
; JAE/JNB ; JumpAboveEqual/JumpNotBelow, CF
; JB/JNAE ; Jump Below/JumpNotAboveEqual, CF
; JBE/JNA ; Jump BelowEqual/JumpNotAbove ; AF, CF
;
; �zel bayrak atlamalar�:
; JCXZ ; Jump e�er CX=0
; JC ; Jump e�er CF=1
; JNC ; Jump e�er CF=0
; JO ; Jump e�er OF=1
; JNO ; Jump e�er OF=0
; JP/JPE ; JumpParity/JumpParityEven e�er PF=1/0
; JNP/JPO ; JumpNoParity/JumpParityOdd e�er PF=0/1
; JS ; JumpSign (negatif de�er) e�er SF=1
; JNS ; JumpNoSign (pozitif de�er) e�er SF=0
;
; CMP AL, BL
; JE E��T
; CMP AL, BH
; JE E��T
; CMP AL, CL
; JE E��T
; E��T_DE��L: ...
; E��T: ...
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov ecx, [Say�1]
    cmp ecx, [Say�2]
    jg ���nc�_say�_kontrolu
    mov ecx, [Say�2]

���nc�_say�_kontrolu:
    cmp ecx, [Say�3]
    jg _��k��
    mov ecx, [Say�3]

_��k��:
    mov [enb�y���], ecx

    mov ecx,Mesaj
    mov edx, Uzunluk
    mov ebx,1	; 1=ekran
    mov eax,4	; 4=yaz
    int 0x80

    mov ecx, enb�y���
    mov edx, 2
    mov ebx,1
    mov eax,4
    int 0x80

    mov eax, 1	; son
    int 80h

	section .data
    Mesaj db "�� say�n�n enb�y���: ", 0xA,0xD
    Uzunluk equ $- Mesaj
    Say�1 dd "22"
    Say�2 dd "47"
    Say�3 dd "31"

	segment .bss
    enb�y��� resb 2