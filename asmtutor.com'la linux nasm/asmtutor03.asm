; asmtutor03.asm: Dizge uzunluðunu programa hesaplattýrma örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Selam, (0=ascii30) mesaj uzunluðunu programýn hesapladýðý dünya!
;----------------------------------------------------------------------------------------------------------------------------------
; ===3.Dizge Uzunluðunun Hesabý===
; Dizgede herbir karakter 1 byte olup, ayrýca sondaki 0xAh'i de 1 byte olarak katmak zorundayýz, yoksa
; nasm sýfýr byte'lý dizge varsayar. CMP karþýlaþtýrma ascii 0=null=hiç kýyaslar; gerçer 0=30 ascii'dir.
;----------------------------------------------------------------------------------------------------------------------------------

	SECTION .data
    Mesaj db "Selam, (0=ascii30) mesaj uzunluðunu programýn hesapladýðý dünya!", 0Ah

	SECTION .text
    global _start
_start:
    mov ebx, Mesaj	; Mesaj'ýn bellek baþlangýç adresi
    mov eax, ebx

birsonraki_karakter:
    cmp byte [eax], 0	; eax'taki tek byte 0'la karþýlaþtýrýlýr
    jz bitti		; Eðer ZF=1'se bitti'ye atlanýr (dizge sonu)
    inc eax		; eax bir sonraki byte/krk'i iþaret eder
    jmp birsonraki_karakter	; dizge bitinceye dek döngüye devam edilir

bitti:
    sub eax, ebx	; eax = eax - ebx (dizgenin son adres byte'ýndan ilki çýkýnca uzunluk krk sayýsý kalýr)

    mov edx, eax	; edx=uzunluk
    mov ecx, Mesaj	; ecx=Mesaj
    mov ebx, 1	; ebx=1=ekran
    mov eax, 4	; eax=4=yaz
    int 80h

    mov ebx, 0	; ebx=0=hatasýz
    mov eax, 1	; eax=1=çýk
    int 80h