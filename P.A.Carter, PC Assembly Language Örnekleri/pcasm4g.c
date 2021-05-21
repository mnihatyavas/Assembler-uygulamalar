/*
 * pcasm4g.c: Bir'den n'e kadar olan tamsay�lar�n fakt�ryeli C �a��ran program �rne�i.
 *
 * Fakt�ryel! hesab� pcasm4g.asm altprogramda ger�ekle�tirilip fonksiyonla d�nd�r�lecek.
 */

#include <stdio.h>
#include "cdecl.h"
int PRE_CDECL faktoryal (int) POST_CDECL; /* assembler rutin prototipi */

int main (void) {
    int n;
    printf ("Fakt�ryeli hesaplanacak �st limiti girin: ");
    scanf ("%d", &n);
    printf ("Heaplanan fakt�ryel: %d\n", faktoryal (n) );
    return 0;
} // main sonu...