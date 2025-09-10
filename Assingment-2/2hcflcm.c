// Q: program to find the HCF and LCM of 2 numbers

#include <stdio.h>

int main() {
    int a, b, hcf, lcm;

    // Input two positive integers
    printf("Enter two positive integers: ");
    scanf("%d %d", &a, &b);

    // Find HCF using the Euclidean Algorithm
    int x = a, y = b;
    while (y != 0) {
        int temp = y;
        y = x % y;
        x = temp;
    }
    hcf = x;

    // Calculate LCM
    lcm = (a * b) / hcf;

    // Display the results
    printf("HCF of %d and %d is %d\n", a, b, hcf);
    printf("LCM of %d and %d is %d\n", a, b, lcm);

    return 0;
}
