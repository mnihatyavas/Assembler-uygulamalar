// pcasm6a.c: �ki k�kl� denklemin ��z�m� C �a��ran program �rne�i.

#include <stdio.h>
#include "cdecl.h"

int PRE_CDECL ciftkok (double, double, double, double *, double *) POST_CDECL;

int main() {
    double a, b, c, kok1, kok2;

    printf ("Herbirini enter'layarak a, b, c girin: ");
    scanf ("%lf %lf %lf", &a, &b, &c);
    if (ciftkok (a, b, c, &kok1, &kok2) ) printf ("\nHesaplanan k�kler: %.10g %.10g\n", kok1, kok2);
    else printf ("\nGer�ek k�kler bulunamad�\n");
    return 0;
} // main sonu...