; tut15.asm: Kodlamalý üç sayýdan enbüðünün bulunmasý örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; üç sayýnýn enbüyüðü: 47
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===ÞARTLAR===
; Þartlar þartsýz JMP/Jump/Atla yada þartlý J<þart> komutuyla akýþý döngü veya dallanma etiketine yönUzunlukdirir.
; CMP/Compare/Kýyasla hedef, kaynak ; sonucunu kritik ederek atlama yapabilir.
; CMP DX, 00
; JE L7 ; Eþitse L7 etiketine atla
; ...
; L7: ...
; 
; DÖNGÜ1:
; INC EDX
; CMP EDX 10
; JLE DÖNGÜ1 ; 10 kez döner
; ...
;
; MOV AX, 00
; MOV BX, 00
; MOV CX, 01
; L20:
; ADD AX, 01 , yada INC AX
; ADD BX, AX ; BX += AX ; 1+2+3+...
; SHL CX, 1 ; ShiftLeft/SolaKay, deðer katlanýr ; 1, 2, 4, 8...
; JMP L20 ; döngüye devam
;
; Ýþaretli veri atlamalarý:
; JE/JZ ; JumpEqual/JumpZero, ZF
; JNE/JNZ ; JumpNotEqual/JumpNotZero, ZF
; JG/JNLE ; JumpGreater/JumpNotLessEqual ; OF, SF, ZF
; JGE/JNL ; JumpGreaterEqual/JumpNotLess ; OF, SF
; JL/JNGE ; Jump Less/JumpNotGreaterEqual ; OF, SF
; JLE/JNG ; JumpLessEqual/JumpNotGreater ; OF, SF, ZF
;
; Ýþaretsiz veri atlamalarý:
; JE/JZ ; Jump Equal/JumpZero, ZF
; JNE/JNZ ; JumpNotEqual/JumpNotZero, ZF
; JA/JNBE ; JumpAbove/JumpNotBelowEqual ; CF, ZF
; JAE/JNB ; JumpAboveEqual/JumpNotBelow, CF
; JB/JNAE ; Jump Below/JumpNotAboveEqual, CF
; JBE/JNA ; Jump BelowEqual/JumpNotAbove ; AF, CF
;
; Özel bayrak atlamalarý:
; JCXZ ; Jump eðer CX=0
; JC ; Jump eðer CF=1
; JNC ; Jump eðer CF=0
; JO ; Jump eðer OF=1
; JNO ; Jump eðer OF=0
; JP/JPE ; JumpParity/JumpParityEven eðer PF=1/0
; JNP/JPO ; JumpNoParity/JumpParityOdd eðer PF=0/1
; JS ; JumpSign (negatif deðer) eðer SF=1
; JNS ; JumpNoSign (pozitif deðer) eðer SF=0
;
; CMP AL, BL
; JE EÞÝT
; CMP AL, BH
; JE EÞÝT
; CMP AL, CL
; JE EÞÝT
; EÞÝT_DEÐÝL: ...
; EÞÝT: ...
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
    mov ecx, [Sayý1]
    cmp ecx, [Sayý2]
    jg üçüncü_sayý_kontrolu
    mov ecx, [Sayý2]

üçüncü_sayý_kontrolu:
    cmp ecx, [Sayý3]
    jg _çýkýþ
    mov ecx, [Sayý3]

_çýkýþ:
    mov [enbüyüðü], ecx

    mov ecx,Mesaj
    mov edx, Uzunluk
    mov ebx,1	; 1=ekran
    mov eax,4	; 4=yaz
    int 0x80

    mov ecx, enbüyüðü
    mov edx, 2
    mov ebx,1
    mov eax,4
    int 0x80

    mov eax, 1	; son
    int 80h

	section .data
    Mesaj db "Üç sayýnýn enbüyüðü: ", 0xA,0xD
    Uzunluk equ $- Mesaj
    Sayý1 dd "22"
    Sayý2 dd "47"
    Sayý3 dd "31"

	segment .bss
    enbüyüðü resb 2