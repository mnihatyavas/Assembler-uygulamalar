/*
 * pcasm4g.c: Bir'den n'e kadar olan tamsayýlarýn faktöryeli C çaðýran program örneði.
 *
 * Faktöryel! hesabý pcasm4g.asm altprogramda gerçekleþtirilip fonksiyonla döndürülecek.
 */

#include <stdio.h>
#include "cdecl.h"
int PRE_CDECL faktoryal (int) POST_CDECL; /* assembler rutin prototipi */

int main (void) {
    int n;
    printf ("Faktöryeli hesaplanacak üst limiti girin: ");
    scanf ("%d", &n);
    printf ("Heaplanan faktöryel: %d\n", faktoryal (n) );
    return 0;
} // main sonu...