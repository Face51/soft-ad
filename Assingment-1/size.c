#include <stdio.h>

int main() {
    printf("Size of all Primitive Datatypes in C:\n");

    printf("Size of short int = %d bytes\n", (int)sizeof(short int));
    printf("Size of unsigned short int = %d bytes\n", (int)sizeof(unsigned short int));
    printf("Size of int = %d bytes\n", (int)sizeof(int));
    printf("Size of unsigned int = %d bytes\n", (int)sizeof(unsigned int));
    printf("Size of long int = %d bytes\n", (int)sizeof(long int));
    printf("Size of unsigned long int = %d bytes\n", (int)sizeof(unsigned long int));
    printf("Size of long long int = %d bytes\n", (int)sizeof(long long int));
    printf("Size of unsigned long long int = %d bytes\n", (int)sizeof(unsigned long long int));
    
    printf("Size of char = %d byte\n", (int)sizeof(char));
    printf("Size of signed char = %d byte\n", (int)sizeof(signed char));
    printf("Size of unsigned char = %d byte\n", (int)sizeof(unsigned char));
    
    printf("Size of float = %d bytes\n", (int)sizeof(float));
    printf("Size of double = %d bytes\n", (int)sizeof(double));
    printf("Size of long double = %d bytes\n", (int)sizeof(long double));

    return 0;
}