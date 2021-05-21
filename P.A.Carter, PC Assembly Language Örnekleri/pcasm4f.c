/*
 * pcasm4f.c: Bir'den n'e kadar olan tamsayýlarýn toplamý C çaðýran program örneði.
 *
 * Toplama hesabý pcasm4f.asm altprogramda gerçekleþtirilip fonksiyonla döndürülecek.
 */

#include <stdio.h>
#include "cdecl.h"
int PRE_CDECL toplam_hesapla (int) POST_CDECL; /* assembler rutin prototipi */

int main (void) {
    int n;
    printf ("Toplamý hesaplanacak üst limiti girin: ");
    scanf ("%d", &n);
    printf ("Heaplanan toplam: %d\n", toplam_hesapla (n) );
    return 0;
} // main sonu...