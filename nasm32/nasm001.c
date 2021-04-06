/* nasm001.c: Merhaba dünya mesajının dos penceresinden yansıtılması örneği.  */

#include <stdio.h>
int main() {
    char mesaj[] = "Merhaba C ve Assembler Dünyası!\n";
    printf ("%s\n", mesaj);
    return 0;
} // main sonu...

// gcc -m32 nasm001.c -o nasm001.exe