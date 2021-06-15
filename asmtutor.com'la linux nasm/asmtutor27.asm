; asmtutor27.asm: SYS_LSEEK ile mevcut dosya içerik konumunda güncelleme örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
;----------------------------------------------------------------------------------------------------------------------------------
; ===27.Dosya Yönetimi (Güncelleme)===
; EAX=19=SYS_LSEEK, EBX=Dosya tasvir no, EDX: (0=SEEK_SET, 1=SEEK_CUR, 2=SEEK_END),
; ECX=Telafi adresi
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    DosyaAdý db "mny1.txt", 0h
    GüncellemeKaydý db "-güncellendi-", 0h

	SECTION .text
    global _start
_start:
    mov ecx, 1	; Eriþim (1=O_WRONLY)
    mov ebx, DosyaAdý
    mov eax, 5	; Baþvur (5=SYS_OPEN)
    int 80h

    mov edx, 2	; Dosya sonu (2=SEEK_END)
    mov ecx, 0	; Telafi adresi 0 byte ileri
    mov ebx, eax	; Dosya açma tasvir no
    mov eax, 19	; Baþvur (19=SYS_LSEEK)
    int 80h

    mov edx, 13	; Uzunluk
    mov ecx, GüncellemeKaydý
    mov ebx, ebx	; Dosya tasvir no
    mov eax, 4	; Baþvur (4=SYS_WRITE)
    int 80h

    call son