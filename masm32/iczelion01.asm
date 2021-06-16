; iczelion01.asm: Win32 pencereden mesaj yazdýrma örneði.
;
; ml  /c  /coff  /Cp iczelion01.asm veya
; ml  /c  /coff iczelion01.asm
; link /SUBSYSTEM:WINDOWS  /LIBPATH:c:\masm32\lib  iczelion01.obj veya
; link /subsystem:windows iczelion01.obj
; iczelion01
;------------------------------------------------------------------------------------------------------------------------------------------

	.386
	.model flat, stdcall
    option casemap:none
    include \masm32\include\windows.inc	; path kabul etmiyor
    include \masm32\include\kernel32.inc	; c: gereksiz, path ipucu veriyor
    include \masm32\include\user32.inc	; /libpath gereksiz
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\user32.lib

	.data
    MesajBasligi db "Iczelion Win32 Eðitim No.2", 0
    MesajMetni db "Büyüksün Win32 Assembler!", 0

	.code
start:
    invoke MessageBox, NULL, addr MesajMetni, addr MesajBasligi, MB_OK
    invoke ExitProcess, NULL
end start

;------------------------------------------------------------------------------------------------------------------------------------------
; path=c:\masm32\bin
; ml  /c  /coff  /Cp msgbox.asm
; /c tells MASM to assemble only. Do not invoke link.exe. Most of the time, you would not want to call link.exe automatically since you may have to perform some other tasks prior to calling link.exe. 
; /coff tells MASM to create .obj file in COFF format. MASM uses a variation of COFF (Common Object File Format) which is used under Unix as its own object and executable file format. 
; /Cp tells MASM to preserve case of user identifiers. If you use hutch's MASM32 package, you may put "option casemap:none" at the head of your source code, just below .model directive to achieve the same effect.
;------------------------------------------------------------------------------------------------------------------------------------------
; link /SUBSYSTEM:WINDOWS  /LIBPATH:c:\masm32\lib  msgbox.obj
; /SUBSYSTEM:WINDOWS  informs Link what sort of executable this program is 
; /LIBPATH:<path to import library> tells Link where the import libraries are. If you use MASM32, they will be in MASM32\lib folder.
;------------------------------------------------------------------------------------------------------------------------------------------