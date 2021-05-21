// pcasm6c.c: Belirtilen adet baþtan asal sayýlarý listeleme C örneði.

#include <stdio.h>
#include <stdlib.h>
#include "cdecl.h"

/* Parametreler:
 *   dizi - asal sayýlar dizisi
 *   n - azami asal sayý adedi
 */

extern void PRE_CDECL asallar_listesi (int * a, unsigned n) POST_CDECL;

int main() {
    int durum;
    unsigned i;
    unsigned azami;
    int * dizi;

    printf ("Baþtan kaç adet asal bulmak istersin? ");
    scanf ("%u", &azami);
    dizi = calloc (sizeof (int), azami);

    if (dizi) {asallar_listesi (dizi, azami);
        // Sadece (fazlaysa) son 20 asallar listelensin istersen: for (i=(azami > 20) ? azami - 20 : 0; i < azami; i++)
        for (i=0; i < azami; i++) printf ("%3d %d\n", i+1, dizi [i]);
        free (dizi);
        durum = 0;
    }else {fprintf (stderr, "%u elemanlýk dizi yaratýlamadý\n", azami);
        durum = 1;
    } // else sonu...
    return durum;
} // main sonu...