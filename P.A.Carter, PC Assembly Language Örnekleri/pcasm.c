// pcasm.c: �lk ASM program�n� �a��racak olan s�r�c� C program� �rne�i.
// Dikkat: De�i�ken adlar�nda t�rk�e karakterleri kabul etmiyor.

#include "cdecl.h"

int PRE_CDECL esas_kodlama ( void ) POST_CDECL;

int main() {
    int durum;
    durum = esas_kodlama();
    return durum;
} // main sonu...