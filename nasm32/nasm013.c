// nasm013.c: Assembler'da mesaj yazdýrma C çaðýrma anaprogramý örneði.

#include <stdio.h>

extern void ekrana_yaz();

int main (void) {
    ekrana_yaz ();
    return 0;
} // main sonu...