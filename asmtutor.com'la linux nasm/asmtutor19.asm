; asmtutor19.asm: SYS_EXECVE ile komut  ve arg�manlar� �al��t��t�rma �rne�i.
;
; "https://www.jdoodle.com/compile-assembler-nasm-online/"
; Merhaba ECHO D�nyas�!
;----------------------------------------------------------------------------------------------------------------------------------
; ===19.Arg�manl� Komutlar===
; SECTION .data
; command db "/bin/echo", 0h ; i�letilecek komut "ECHO"
; arg1 db "Merhaba ECHO D�nyas�!", 0h ; komutun yans�taca�� mesaj
;
; SECTION .data
; command db "/bin/ls", 0h ; i�letilecek komut
; arg1 db "-l", 0h ; komutun listeyece�i dosyalar
;==>
; total 20

; -rwxr-xr-x 1 root root 8404 Jun 12 01:49 jdoodle
; 
-rw-r--r-- 1 root root  579 Jun 12 01:49 jdoodle.asm
; 
-rw-r--r-- 1 root root 1344 Jun 12 01:49 jdoodle.o
;
; SECTION .data
; command db "/bin/sleep", 0h ; i�letilecek komut
; arg1 db "5", 0h ; komutun i�letilece�i s�re (5 sn uyu-bekle)
;==>
; CPU Time: 0.00 sec(s), Memory: 1552 kilobyte(s) compiled and executed in 5.922 sec(s)
;----------------------------------------------------------------------------------------------------------------------------------

    %include "asmtutor05x.asm"

	SECTION .data
    komut db "/bin/echo", 0h
    arg�man1 db "Merhaba ECHO D�nyas�!", 0h
    arg�manlar dd komut
	dd arg�man1	; Komutsat�r�na ge�irilecek arg�manlar
	dd 0h	; yap� sonu
    �evre dd 0h ; �evre de�i�kenine ge�irilecek arg�manlar

	SECTION .text
    global _start
_start:
    mov edx, �evre		; veri uzunlu�u
    mov ecx, arg�manlar	; i�letilecek veri
    mov ebx, komut		; i�letilecek dosya adresi
    mov eax, 11		; ba�vur 11=SYS_EXECVE
    int 80h
    call son