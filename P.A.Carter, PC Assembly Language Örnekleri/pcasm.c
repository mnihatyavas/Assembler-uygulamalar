// pcasm.c: Ýlk ASM programýný çaðýracak olan sürücü C programý örneði.
// Dikkat: Deðiþken adlarýnda türkçe karakterleri kabul etmiyor.

#include "cdecl.h"

int PRE_CDECL esas_kodlama ( void ) POST_CDECL;

int main() {
    int durum;
    durum = esas_kodlama();
    return durum;
} // main sonu...