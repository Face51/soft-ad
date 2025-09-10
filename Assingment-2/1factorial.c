// Q: program to find the factorial of a number
#include <stdio.h>

int main() {
    int n, i, fact = 1;

    // Input a positive integer
    printf("Enter a positive integer: ");
    scanf("%d", &n);

    // Compute factorial
    for (i = 1; i <= n; i++) {
        fact = fact * i;
    }

    // Display the result
    printf("Factorial of %d is %d\n", n, fact);

    return 0;
}
