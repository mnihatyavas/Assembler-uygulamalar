// pcasm2b.c: Belirtilen üstLimite kadarki asal sayýlarý hesaplayan C örneði.
// gcc -m32 pcasm2b.c -o pcasm2b.exe

#include <stdio.h>

int main() {
    unsigned altAsal; //Üst limitin alt asalarý
    unsigned bolunen; // Alt asalýn muhtemel bölüneni
    unsigned ustLimit; // Üst limite kadarki alt asallar bulunacak
    unsigned i = 3;

    printf ("Asallarý bulunacak 5 ve üstü limit? ");
    scanf ("%u", &ustLimit);

    printf ("1) 1\n"); // Ýlk 3 asal (1, 2, 3) standarttýr...
    printf ("2) 2\n"); // Asal olan çift sayý sadece 2'dir...
    printf ("3) 3\n");

    altAsal = 5; // Girilecek limit altý Ýlk asalsayý...
    while (altAsal <= ustLimit) { // altAsal'ýn tekli bölünenei araþtýrýlýyor...
        bolunen = 3;
        while (bolunen * bolunen < altAsal && altAsal % bolunen != 0) bolunen += 2;
        if (altAsal % bolunen != 0 ) // Bölüm kalaný != 0 ise bölünensiz ve asaldýr..
            printf ("%d) %d\n", ++i, altAsal);
        altAsal += 2; // Çift sayýlar 2'ye bölündüðünden sadece tek sayýlarýn asallýðý araþtýrýlacak
    } // while sonu...
    return 0;
} // main sonu...
