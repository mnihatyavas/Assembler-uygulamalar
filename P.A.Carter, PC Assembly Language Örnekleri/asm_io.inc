; asm_io.inc: Di�er programlara %include ile dahil edilecek okuma-yazma rutinleri �rne�i.
;
; Burdaki extern rutinler ise asm_io.asm ==> asm_io.exe program�ndan �a�r�lmaktad�r.
;----------------------------------------------------------------------------------------------------------------------------

    extern oku_tms, oku_krk
    extern yaz_tms, yaz_krk, yaz_dizge, yaz_hi�
    extern kay�t��lar�_bo�alt, belle�i_bo�alt, matemati�i_bo�alt, y���n�_bo�alt

%macro kay�t��lar�_bo�alt 1
    push dword %1
    call kay�t��lar�_bo�alt
%endmacro

%macro belle�i_bo�alt 3
    push dword %1
    push dword %2
    push dword %3
    call belle�i_bo�alt
%endmacro

%macro matemati�i_bo�alt 1
    push dword %1
    call matemati�i_bo�alt
%endmacro

%macro y���n�_bo�alt 3
    push dword %3
    push dword %2
    push dword %1
    call y���n�_bo�alt
%endmacro