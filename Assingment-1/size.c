#include <stdio.h>

int main() {
    printf("Size of all Primitive Datatypes in C:\n");

    // Integer types
    printf("Size of short int = %hd bytes\n", sizeof(short int));
    printf("Size of unsigned short int = %hu bytes\n", sizeof(unsigned short int));
    printf("Size of int = %d bytes\n", sizeof(int));
    printf("Size of unsigned int = %u bytes\n", sizeof(unsigned int));
    printf("Size of long int = %ld bytes\n", sizeof(long int));
    printf("Size of unsigned long int = %lu bytes\n", sizeof(unsigned long int));
    printf("Size of long long int = %lld bytes\n", sizeof(long long int));
    printf("Size of unsigned long long int = %llu bytes\n", sizeof(unsigned long long int));

    // Character types
    printf("Size of char = %d byte\n", sizeof(char));
    printf("Size of signed char = %hhd byte\n", sizeof(signed char));
    printf("Size of unsigned char = %hhu byte\n", sizeof(unsigned char));

    // Floating-point types
    printf("Size of float = %d bytes\n", sizeof(float));
    printf("Size of double = %d bytes\n", sizeof(double));
    printf("Size of long double = %d bytes\n", sizeof(long double));

    return 0;
}
