// nasm001b.c: Merhaba d�nya mesaj�n�n dos penceresinden yans�t�lmas� C �rne�i.
// gcc -m32 nasm001b.c -o nasm001b.exe	; yada k�saca (gcc -m32 nasm001b.c)

#include <stdio.h>

int main() {
    char mesaj [] = "Merhaba C D�nyas�!\n";
    printf ("%s\n", mesaj);
    return 0;
} // main sonu...