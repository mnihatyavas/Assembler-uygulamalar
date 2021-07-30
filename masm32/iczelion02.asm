; iczelion02.asm: Win32 pencereden mesaj yazdýrma örneði.
;
; ml  /c  /coff  /Cp iczelion02.asm veya
; ml  /c  /coff iczelion02.asm
; link /SUBSYSTEM:WINDOWS  /LIBPATH:c:\masm32\lib  iczelion02.obj veya
; link /subsystem:windows iczelion02.obj
; iczelion02
;------------------------------------------------------------------------------------------------------------------------------------------
;===1.TEMELLER===
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
; Windows içsel olarak  esi, edi, ebp ve ebx kayýtçýlarýný kullanýr;bu yüzden her an içerikleri deðiþebilir. Altrutilere gitmeden
; önce bu kayýtçýlar yýðýna konulmalý ve geridönüþte tekrar alýnmalýdýr.
;
; Bir masm32 program iskeleti:
; .386	; Siz iyisimi hep bunu benimseyin!..
; .MODEL Flat, STDCALL	; Flat: düz bellek modeli; stdcall: C argümanlarý saðdan-sola, pascal yýðýna soldan-saða koyar, masm32 melezini kullanýr.
; .DATA
;    <Ýlkdeðerli deðiþkenler>
;    ...
; .DATA?
;   <Ýlkdeðersiz deðiþkenler> 
;   ...
; .CONST
;   <Sabit deðiþkenler> 
;   ...
; .CODE
; <etiket/start>:
;    <Kodlama> 
;   ...
; end <etiket/start> 
;------------------------------------------------------------------------------------------------------------------------------------------
;===2.MESAJ KUTUSU===
; Windows'un kullandýðý API/ApplicationProgrammingInterface)'ler genellikle Kernel32.dll, User32.dll ve grafikler Gdi32.dll
; içinde bulunur; pek çok baþkalarý da mevcuttur.
; 1 byte'lýk (toplam 2^8=256) karakterli ANSI API fonksiyonlarýn sonunda A (MessageBoxA), 2 byte'lýk (toplam
; 2^16=65536) karakterli UNICODE fonksiyonlarýn sonundaysa U (MessageBoxU) bulunur.
; Fonksiyon prototipleri:
; FonksiyonAdý PROTO [ParametreAdý1]:VeriTipi, [ParametreAdý2]:VeriTipi, ...
; ExitProcess proto uExitCode:DWORD
; invoke ExitProcess, NULL	; yada: invoke ExitProcess, 0
; invoke/baþvur fonksiyon adý ve argümanlar adý gerektirrir, call/çaðýr ise argümansýzdýr, ancak argümanlarý siz yýðýna koymalýsýnýz.
; Fonksiyon prototipleri kernel32.inc/dll'deyse fonksiyon ihracý kernel32.lib'den yapýlýr.
; option casemap:none ile etiketadlarý büyük/küçük-harf duyarlý yapýlýr. ML /Cp ile aynýdýr.
; import fonksiyonlar dosyasýna includelib'le yol verilmezse, komut satýrýndan girilmelidir; ancak yorucu ve 128 krk'i geçemez.
;
; MessageBox prototipi: MessageBox PROTO hwnd:DWORD, lpText:DWORD, lpCaption:DWORD, uType:DWORD
; Ve baþvurusu: invoke MessageBox, NULL, addr MesajMetni, addr MesajBasligi, MB_OK
; Eðer .data mesaj deðiþkenleri invoke sonrasýyerleþtirilmiþse addr yerine offset/telafi kullanýlmalýdýr.
; addr lokal deðiþkenleri de yönetebilirken offset sadece globalleri yönetir.
;------------------------------------------------------------------------------------------------------------------------------------------

	.386
	.model flat, stdcall
    option casemap:none		; ML /Cp artýk gerekmez
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