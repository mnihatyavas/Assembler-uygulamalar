// nasm013.c: Assembler'da mesaj yazd�rma C �a��rma anaprogram� �rne�i.

#include <stdio.h>

extern void ekrana_yaz();

int main (void) {
    ekrana_yaz ();
    return 0;
} // main sonu...