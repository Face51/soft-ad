#include <stdio.h>
int main() {
    // printing the sizes of all primitive datatypes in C:
    printf("Size of all Primitive Datatypes in C:");
    printf("\nSize of short int = %zu bytes", sizeof(short int));
    printf("\nSize of unsigned short int = %zu bytes", sizeof(unsigned short int));
    printf("\nSize of int = %zu bytes", sizeof(int));
    printf("\nSize of unsigned int = %zu bytes", sizeof(unsigned int));
    printf("\nSize of long int = %zu bytes", sizeof(long int));
    printf("\nSize of unsigned long int = %zu bytes", sizeof(unsigned long int));
    printf("\nSize of long long int = %zu bytes", sizeof(long long int));
    printf("\nSize of unsigned long long int = %zu bytes", sizeof(unsigned long long int));
    printf("\nSize of char = %zu byte", sizeof(char));
    printf("\nSize of signed char = %zu byte", sizeof(signed char));
    printf("\nSize of unsigned char = %zu byte", sizeof(unsigned char));
    printf("\nSize of float = %zu bytes", sizeof(float));
    printf("\nSize of double = %zu bytes", sizeof(double));
    printf("\nSize of long double = %zu bytes", sizeof(long double));
    return 0;
}
