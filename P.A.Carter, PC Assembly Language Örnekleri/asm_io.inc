; asm_io.inc: Diðer programlara %include ile dahil edilecek okuma-yazma rutinleri örneði.
;
; Burdaki extern rutinler ise asm_io.asm ==> asm_io.exe programýndan çaðrýlmaktadýr.
;----------------------------------------------------------------------------------------------------------------------------

    extern oku_tms, oku_krk
    extern yaz_tms, yaz_krk, yaz_dizge, yaz_hiç
    extern kayýtçýlarý_boþalt, belleði_boþalt, matematiði_boþalt, yýðýný_boþalt

%macro kayýtçýlarý_boþalt 1
    push dword %1
    call kayýtçýlarý_boþalt
%endmacro

%macro belleði_boþalt 3
    push dword %1
    push dword %2
    push dword %3
    call belleði_boþalt
%endmacro

%macro matematiði_boþalt 1
    push dword %1
    call matematiði_boþalt
%endmacro

%macro yýðýný_boþalt 3
    push dword %3
    push dword %2
    push dword %1
    call yýðýný_boþalt
%endmacro