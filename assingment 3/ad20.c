#include <stdio.h>

int main() {
    int decimal, remainder, i = 0;
    int binary[sizeof(int) * 8];  // Array to store binary digits

    // Input decimal number
    printf("Enter a decimal number: ");
    scanf("%d", &decimal);

    if (decimal == 0) {
        printf("Binary: 0\n");
        return 0;
    }

    // Convert decimal to binary
    while (decimal > 0) {
        remainder = decimal % 2;
        binary[i++] = remainder;
        decimal /= 2;
    }

    // Print binary number in correct order
    printf("Binary: ");
    for (i = i - 1; i >= 0; i--)
        printf("%d", binary[i]);
    printf("\n");

    return 0;
}