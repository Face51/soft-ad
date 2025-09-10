// Q: program to find the sum of each digit raised to the power of itself in a given number

#include <stdio.h>

int main() {
    int n, sum = 0, d, i;

    // Input a positive integer
    printf("Enter a positive integer: ");
    scanf("%d", &n);

    // Validate input
    if (n <= 0) {
        printf("Please enter a positive integer.\n");
        return 1;
    }

    int temp = n; // Store original number if needed

    // Process each digit
    while (n != 0) {
        d = n % 10;  // Extract last digit
        int p = 1;

        // Calculate d^d
        for (i = 0; i < d; i++) {
            p *= d;
        }

        sum += p;    // Add to sum
        n /= 10;     // Remove last digit
    }

    // Display the result
    printf("The result is %d\n", sum);

    return 0;
}
