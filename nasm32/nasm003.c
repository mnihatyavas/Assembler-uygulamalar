// nasm003.c: Assembler program�ndaki fonksiyonun C'den �a�r�lmas� �rne�i.

#include <stdio.h>

int enBuyugu (int, int, int); // T�rk�e karakterleri kabul etmiyor...

int main() {
    printf ("%d\n", enBuyugu (1, -4, -7)); // 1
    printf ("%d\n", enBuyugu (2, 4, 6)); // 6
    printf ("%d\n", enBuyugu (2, -6, 1)); // 2
    printf ("%d\n", enBuyugu (2, 3, 1)); // 3
    printf ("%d\n", enBuyugu (-20, -4, -13)); // -4
    printf ("%d\n", enBuyugu (2, -6, 5)); // 5
    printf ("%d\n", enBuyugu (-0, -4, -13)); // 0
    return 0;
} // main sonu...