// nasm003.c: Assembler programýndaki fonksiyonun C'den çaðrýlmasý örneði.

#include <stdio.h>

int enBuyugu (int, int, int); // Türkçe karakterleri kabul etmiyor...

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