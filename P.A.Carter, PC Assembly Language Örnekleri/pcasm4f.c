/*
 * pcasm4f.c: Bir'den n'e kadar olan tamsay�lar�n toplam� C �a��ran program �rne�i.
 *
 * Toplama hesab� pcasm4f.asm altprogramda ger�ekle�tirilip fonksiyonla d�nd�r�lecek.
 */

#include <stdio.h>
#include "cdecl.h"
int PRE_CDECL toplam_hesapla (int) POST_CDECL; /* assembler rutin prototipi */

int main (void) {
    int n;
    printf ("Toplam� hesaplanacak �st limiti girin: ");
    scanf ("%d", &n);
    printf ("Heaplanan toplam: %d\n", toplam_hesapla (n) );
    return 0;
} // main sonu...