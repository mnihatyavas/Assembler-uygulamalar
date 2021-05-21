// pcasm2b.c: Belirtilen �stLimite kadarki asal say�lar� hesaplayan C �rne�i.
// gcc -m32 pcasm2b.c -o pcasm2b.exe

#include <stdio.h>

int main() {
    unsigned altAsal; //�st limitin alt asalar�
    unsigned bolunen; // Alt asal�n muhtemel b�l�neni
    unsigned ustLimit; // �st limite kadarki alt asallar bulunacak
    unsigned i = 3;

    printf ("Asallar� bulunacak 5 ve �st� limit? ");
    scanf ("%u", &ustLimit);

    printf ("1) 1\n"); // �lk 3 asal (1, 2, 3) standartt�r...
    printf ("2) 2\n"); // Asal olan �ift say� sadece 2'dir...
    printf ("3) 3\n");

    altAsal = 5; // Girilecek limit alt� �lk asalsay�...
    while (altAsal <= ustLimit) { // altAsal'�n tekli b�l�nenei ara�t�r�l�yor...
        bolunen = 3;
        while (bolunen * bolunen < altAsal && altAsal % bolunen != 0) bolunen += 2;
        if (altAsal % bolunen != 0 ) // B�l�m kalan� != 0 ise b�l�nensiz ve asald�r..
            printf ("%d) %d\n", ++i, altAsal);
        altAsal += 2; // �ift say�lar 2'ye b�l�nd���nden sadece tek say�lar�n asall��� ara�t�r�lacak
    } // while sonu...
    return 0;
} // main sonu...
