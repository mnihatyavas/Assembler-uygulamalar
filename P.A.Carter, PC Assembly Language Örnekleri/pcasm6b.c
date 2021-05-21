// pcasm6b.c: Klavyeden girilen ondal�k say�lar� altalta sunan C �rne�i.

#include <stdio.h>
#include "cdecl.h"

extern int PRE_CDECL duble_oku (FILE *, double *, int) POST_CDECL;

#define AZAMi 100

int main() {
    int i, n;
    double a [AZAMi];
    printf ("Altalta azami 100 adet ondal�k say�y� enter'layarak girin [son]: \n");
    n = duble_oku (stdin, a, AZAMi);
    for (i=0; i < n; i++ ) printf ("%3d %g\n", i, a [i]);
    return 0;
} // main sonu...