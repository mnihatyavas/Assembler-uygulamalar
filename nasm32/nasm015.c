// nasm015.c: Komut satýrýndan girilen 2 tamsayýnýn toplamýný veren C örneði.
// gcc -m32 nasm015.c -o nasm015.exe
// nasm015 24 76

#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[]) {
    int n1, n2;
    n1 = atoi (argv [1]);
    n2 = atoi (argv [2]);
    printf ("Girilen 2 -+tamsayýnýn toplamý: %d\n", (n1 + n2) );
    return 0;
} // main sonu...