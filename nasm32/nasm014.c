// nasm014.c: Klavyeden girilen 2 tamsay�y� toplayan C �rne�i.
// gcc -m32 nasm014.c

#include <stdio.h>

int main (int argc, char *argv []) {
    int n1, n2;
    printf ("�lk tamsay�y� girin: ");
    scanf ("%d", &n1);
    printf ("�kinci tamsay�y� girin: ");
    scanf ("%d", &n2);
    printf ("Girilen 2 tamsay�n�n toplam�: %d\n", (n1 + n2) );
    return 0;
} // main sonu...