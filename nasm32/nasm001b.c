// nasm001b.c: Merhaba dünya mesajının dos penceresinden yansıtılması C örneği.
// gcc -m32 nasm001b.c -o nasm001b.exe	; yada kısaca (gcc -m32 nasm001b.c)

#include <stdio.h>

int main() {
    char mesaj [] = "Merhaba C Dünyası!\n";
    printf ("%s\n", mesaj);
    return 0;
} // main sonu...