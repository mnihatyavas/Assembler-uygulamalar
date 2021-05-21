// nasm014.c: Klavyeden girilen 2 tamsayýyý toplayan C örneði.
// gcc -m32 nasm014.c

#include <stdio.h>

int main (int argc, char *argv []) {
    int n1, n2;
    printf ("Ýlk tamsayýyý girin: ");
    scanf ("%d", &n1);
    printf ("Ýkinci tamsayýyý girin: ");
    scanf ("%d", &n2);
    printf ("Girilen 2 tamsayýnýn toplamý: %d\n", (n1 + n2) );
    return 0;
} // main sonu...