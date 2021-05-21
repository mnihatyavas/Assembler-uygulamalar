/*
 * pcasm4e.c: Bir'den n'e kadar olan tamsayýlarýn toplamý C çaðýran program örneði.
 *
 * Toplama hesabý pcasm4e.asm altprogramda gerçekleþtirilir.
 */

#include <stdio.h>
#include "cdecl.h"
void PRE_CDECL toplam_hesapla ( int, int * ) POST_CDECL; /* assembler rutin prototipi */

int main (void) {
    int n, toplam;
    printf ("Toplamý hesaplanacak üst limiti girin: ");
    scanf ("%d", &n);
    toplam_hesapla (n, &toplam);
    printf ("Heaplanan toplam: %d\n", toplam);
    return 0;
} // main sonu...