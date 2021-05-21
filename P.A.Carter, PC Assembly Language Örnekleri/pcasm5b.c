// pcasm5b.c: Girilen karakteri ve dizgeyi asm altprogramlarda i�leme C �rne�i.

#include <stdio.h>
#include "cdecl.h"

#define DiZGE_EBATI 60

// Prototipler:
void PRE_CDECL asm_kopyala (void *, const void *, unsigned) POST_CDECL;
void * PRE_CDECL asm_bul (const void *, char hedef, unsigned) POST_CDECL;
unsigned PRE_CDECL asm_uzunluk (const char *) POST_CDECL;
void PRE_CDECL asm_dzgkopya (char *, const char *) POST_CDECL;

int main() {
    char dizge1 [DiZGE_EBATI] = "Girilen karakterin, i�inde ara�t�r�laca�� test dizgesi!..";
    char dizge2 [DiZGE_EBATI];
    char * dizge;
    char krk;

    asm_kopyala (dizge2, dizge1, DiZGE_EBATI);  // Dizge1'den dizge2'ye t�m 60 krk kopyalan�r
    printf ("Test dizgesi: [%s]\n", dizge2);

    printf ("\nAra�t�r�lacak bir karakter gir: ");  // Girilecek rktest dizgesinde aranacak
    scanf ("%c%*[^\n]", &krk);
    dizge = asm_bul (dizge2, krk, DiZGE_EBATI);
    if (dizge) printf ("BULUNDU: %s\n", dizge);
    else printf ("BULUNMADI\n");

    dizge1 [0] = 0; // 0=NULL
    printf ("\nBo�luksuz bir dizge gir: ");
    scanf ("%s", dizge1);
    printf ("Girdi�iniz dizgenin uzunlu�u = %u\n", asm_uzunluk (dizge1) );

    asm_dzgkopya (dizge2, dizge1); // Girilen dizge di�erine kopyalan�r
    printf ("\nGirilenden kopyalanan dizge: %s\n", dizge2);

    return 0;
} // main sonu...