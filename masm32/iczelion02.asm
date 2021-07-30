; iczelion02.asm: Win32 pencereden mesaj yazd�rma �rne�i.
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
; Windows i�sel olarak  esi, edi, ebp ve ebx kay�t��lar�n� kullan�r;bu y�zden her an i�erikleri de�i�ebilir. Altrutilere gitmeden
; �nce bu kay�t��lar y���na konulmal� ve gerid�n��te tekrar al�nmal�d�r.
;
; Bir masm32 program iskeleti:
; .386	; Siz iyisimi hep bunu benimseyin!..
; .MODEL Flat, STDCALL	; Flat: d�z bellek modeli; stdcall: C arg�manlar� sa�dan-sola, pascal y���na soldan-sa�a koyar, masm32 melezini kullan�r.
; .DATA
;    <�lkde�erli de�i�kenler>
;    ...
; .DATA?
;   <�lkde�ersiz de�i�kenler> 
;   ...
; .CONST
;   <Sabit de�i�kenler> 
;   ...
; .CODE
; <etiket/start>:
;    <Kodlama> 
;   ...
; end <etiket/start> 
;------------------------------------------------------------------------------------------------------------------------------------------
;===2.MESAJ KUTUSU===
; Windows'un kulland��� API/ApplicationProgrammingInterface)'ler genellikle Kernel32.dll, User32.dll ve grafikler Gdi32.dll
; i�inde bulunur; pek �ok ba�kalar� da mevcuttur.
; 1 byte'l�k (toplam 2^8=256) karakterli ANSI API fonksiyonlar�n sonunda A (MessageBoxA), 2 byte'l�k (toplam
; 2^16=65536) karakterli UNICODE fonksiyonlar�n sonundaysa U (MessageBoxU) bulunur.
; Fonksiyon prototipleri:
; FonksiyonAd� PROTO [ParametreAd�1]:VeriTipi, [ParametreAd�2]:VeriTipi, ...
; ExitProcess proto uExitCode:DWORD
; invoke ExitProcess, NULL	; yada: invoke ExitProcess, 0
; invoke/ba�vur fonksiyon ad� ve arg�manlar ad� gerektirrir, call/�a��r ise arg�mans�zd�r, ancak arg�manlar� siz y���na koymal�s�n�z.
; Fonksiyon prototipleri kernel32.inc/dll'deyse fonksiyon ihrac� kernel32.lib'den yap�l�r.
; option casemap:none ile etiketadlar� b�y�k/k���k-harf duyarl� yap�l�r. ML /Cp ile ayn�d�r.
; import fonksiyonlar dosyas�na includelib'le yol verilmezse, komut sat�r�ndan girilmelidir; ancak yorucu ve 128 krk'i ge�emez.
;
; MessageBox prototipi: MessageBox PROTO hwnd:DWORD, lpText:DWORD, lpCaption:DWORD, uType:DWORD
; Ve ba�vurusu: invoke MessageBox, NULL, addr MesajMetni, addr MesajBasligi, MB_OK
; E�er .data mesaj de�i�kenleri invoke sonras�yerle�tirilmi�se addr yerine offset/telafi kullan�lmal�d�r.
; addr lokal de�i�kenleri de y�netebilirken offset sadece globalleri y�netir.
;------------------------------------------------------------------------------------------------------------------------------------------

	.386
	.model flat, stdcall
    option casemap:none		; ML /Cp art�k gerekmez
    include \masm32\include\windows.inc	; path kabul etmiyor
    include \masm32\include\kernel32.inc	; c: gereksiz, path ipucu veriyor
    include \masm32\include\user32.inc	; /libpath gereksiz
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\user32.lib

	.data
    MesajBasligi db "Iczelion Win32 E�itim No.2", 0
    MesajMetni db "B�y�ks�n Win32 Assembler!", 0

	.code
start:
    invoke MessageBox, NULL, addr MesajMetni, addr MesajBasligi, MB_OK
    invoke ExitProcess, NULL
end start