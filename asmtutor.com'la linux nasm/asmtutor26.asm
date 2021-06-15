; asmtutor26.asm: SYS_CLOSE ile içeriði okunan disk dosyasýnýn kapatýlmasý örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Merhaba, yaratýlýp içine kaydedilenin okunup kapatýlan disk dosyasý!
;----------------------------------------------------------------------------------------------------------------------------------
; ===26.Okunan Disk Dosyasýnýn Kapatýlmasý===
; EBX=Dosya tasvir no, EAX=6=SYS_CLOSE
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAdý db "mny1.txt", 0h
    YazýlanKayýt db "Merhaba, yaratýlýp içine kaydedilenin okunup kapatýlan disk dosyasý!", 0h

	SECTION .bss
    okunanKayýt resb 255	; Dosyadan okunacak kaydýn yükleneceði bellek deðiþkeni

	SECTION .text
    global _start
_start:
    mov ecx, 0777	; Yaratýlan dosya eriþimi (oku, yaz, koþtur)
    mov ebx, DosyaAdý
    mov eax, 8	; Baþvur 8=sys_creat
    int 80h

    mov edx, 72	; Dosyaya yazýlacak kayýt uzunluðu
    mov ecx, YazýlanKayýt
    mov ebx, eax	; Dosya tasvir no
    mov eax, 4	; Baþvur 4=sys_write
    int 80h

    mov ecx, 0	; Açýlacak dosya eriþimi (0=O_RDONLY
    mov ebx, DosyaAdý
    mov eax, 5	; Baþvur 5=sys=read
    int 80h

    mov edx, 72	; Dosyadan okunacak kaydýn uzunluðu
    mov ecx, okunanKayýt
    mov ebx, eax	; Açýlan dosya tasvir no
    mov eax, 3	; Baþvur 3=SYS_READ
    int 80h

    mov eax, okunanKayýt
    call dyazAS

    mov ebx, ebx	; Gereksiz, ancak EBX=Dosya tasvir no
    mov eax, 6	; Baþvur 6=SYS_CLOSE
    int 80h

    call son