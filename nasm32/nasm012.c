// nasm012.c: Verilen bir tamsay�n�n fakt�riyelini hesaplama �rne�i.
// T�rk�e de�i�ken adlar�n� kabul etmiyor...

#include <stdio.h>
extern int faktoriyal (int);

int main (void) {
    printf ("16! = %d\n", faktoriyal (16) ); // -1 hata, 0=1, 1=1, 5=120, azami 16=2.004.189.184
    return 0;
} // main sonu...