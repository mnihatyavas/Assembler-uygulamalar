// pcasm5a.c: Dizi elemanlar�n� g�r�nt�leyen asm'nin s�r�c�s� C �a��ran program �rne�i.

#include <stdio.h>
#include "cdecl.h"

int PRE_CDECL esas_kodlama ( void ) POST_CDECL;
void PRE_CDECL veri_kontrolu ( void ) POST_CDECL;

int main() {
    int donen_durum;
    donen_durum = esas_kodlama();
    return donen_durum;
} // main sonu...


void veri_kontrolu() {
    int krk;
    while ( (krk = getchar()) != EOF && krk != '\n');
} // ver..sonu...