/*
 * pcasm4e.c: Bir'den n'e kadar olan tamsay�lar�n toplam� C �a��ran program �rne�i.
 *
 * Toplama hesab� pcasm4e.asm altprogramda ger�ekle�tirilir.
 */

#include <stdio.h>
#include "cdecl.h"
void PRE_CDECL toplam_hesapla ( int, int * ) POST_CDECL; /* assembler rutin prototipi */

int main (void) {
    int n, toplam;
    printf ("Toplam� hesaplanacak �st limiti girin: ");
    scanf ("%d", &n);
    toplam_hesapla (n, &toplam);
    printf ("Heaplanan toplam: %d\n", toplam);
    return 0;
} // main sonu...