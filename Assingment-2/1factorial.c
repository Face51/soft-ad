// Q: program to find the factorial of a number
#include <stdio.h>

int main() {
    int n, i, fact = 1;

    // Input a positive integer
    printf("Enter a positive integer: ");
    scanf("%d", &n);

    if (n >= 0) {
        // Compute factorial if the input is non-negative
        for (i = 1; i <= n; i++) {
            fact = fact * i;
        }
        // Display the result
        printf("Factorial of %d is %d\n", n, fact);
    }
    else {
        // Handle negative input
        printf("Factorial is not defined for negative numbers.\n");
    }

    return 0;
}
