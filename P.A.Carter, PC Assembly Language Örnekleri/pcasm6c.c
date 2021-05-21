// pcasm6c.c: Belirtilen adet ba�tan asal say�lar� listeleme C �rne�i.

#include <stdio.h>
#include <stdlib.h>
#include "cdecl.h"

/* Parametreler:
 *   dizi - asal say�lar dizisi
 *   n - azami asal say� adedi
 */

extern void PRE_CDECL asallar_listesi (int * a, unsigned n) POST_CDECL;

int main() {
    int durum;
    unsigned i;
    unsigned azami;
    int * dizi;

    printf ("Ba�tan ka� adet asal bulmak istersin? ");
    scanf ("%u", &azami);
    dizi = calloc (sizeof (int), azami);

    if (dizi) {asallar_listesi (dizi, azami);
        // Sadece (fazlaysa) son 20 asallar listelensin istersen: for (i=(azami > 20) ? azami - 20 : 0; i < azami; i++)
        for (i=0; i < azami; i++) printf ("%3d %d\n", i+1, dizi [i]);
        free (dizi);
        durum = 0;
    }else {fprintf (stderr, "%u elemanl�k dizi yarat�lamad�\n", azami);
        durum = 1;
    } // else sonu...
    return durum;
} // main sonu...