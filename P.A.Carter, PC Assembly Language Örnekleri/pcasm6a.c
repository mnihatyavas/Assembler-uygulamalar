// pcasm6a.c: Ýki köklü denklemin çözümü C çaðýran program örneði.

#include <stdio.h>
#include "cdecl.h"

int PRE_CDECL ciftkok (double, double, double, double *, double *) POST_CDECL;

int main() {
    double a, b, c, kok1, kok2;

    printf ("Herbirini enter'layarak a, b, c girin: ");
    scanf ("%lf %lf %lf", &a, &b, &c);
    if (ciftkok (a, b, c, &kok1, &kok2) ) printf ("\nHesaplanan kökler: %.10g %.10g\n", kok1, kok2);
    else printf ("\nGerçek kökler bulunamadý\n");
    return 0;
} // main sonu...