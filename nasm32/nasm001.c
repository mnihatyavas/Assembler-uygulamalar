/* nasm001.c: Merhaba d�nya mesaj�n�n dos penceresinden yans�t�lmas� �rne�i.  */

#include <stdio.h>
int main() {
    char mesaj[] = "Merhaba C ve Assembler D�nyas�!\n";
    printf ("%s\n", mesaj);
    return 0;
} // main sonu...

// gcc -m32 nasm001.c -o nasm001.exe