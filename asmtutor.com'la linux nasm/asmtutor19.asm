; asmtutor19.asm: SYS_EXECVE ile komut  ve argümanlarý çalýþtýþtýrma örneði.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Merhaba ECHO Dünyasý!
;----------------------------------------------------------------------------------------------------------------------------------
; ===19.Argümanlý Komutlar===
; SECTION .data
; command db "/bin/echo", 0h ; iþletilecek komut "ECHO"
; arg1 db "Merhaba ECHO Dünyasý!", 0h ; komutun yansýtacaðý mesaj
;
; SECTION .data
; command db "/bin/ls", 0h ; iþletilecek komut
; arg1 db "-l", 0h ; komutun listeyeceði dosyalar
;==>
; total 20

; -rwxr-xr-x 1 root root 8404 Jun 12 01:49 jdoodle
; 
-rw-r--r-- 1 root root  579 Jun 12 01:49 jdoodle.asm
; 
-rw-r--r-- 1 root root 1344 Jun 12 01:49 jdoodle.o
;
; SECTION .data
; command db "/bin/sleep", 0h ; iþletilecek komut
; arg1 db "5", 0h ; komutun iþletileceði süre (5 sn uyu-bekle)
;==>
; CPU Time: 0.00 sec(s), Memory: 1552 kilobyte(s) compiled and executed in 5.922 sec(s)
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    komut db "/bin/echo", 0h
    argüman1 db "Merhaba ECHO Dünyasý!", 0h
    argümanlar dd komut
	dd argüman1	; Komutsatýrýna geçirilecek argümanlar
	dd 0h	; yapý sonu
    çevre dd 0h ; çevre deðiþkenine geçirilecek argümanlar

	SECTION .text
    global _start
_start:
    mov edx, çevre		; veri uzunluðu
    mov ecx, argümanlar	; iþletilecek veri
    mov ebx, komut		; iþletilecek dosya adresi
    mov eax, 11		; baþvur 11=SYS_EXECVE
    int 80h
    call son