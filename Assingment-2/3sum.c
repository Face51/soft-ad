// Q: program to find the sum of first n natural numbers

#include <stdio.h>

int main() {
    int n, i, sum = 0;

    // Input a positive integer
    printf("Enter a positive integer: ");
    scanf("%d", &n);

    // Check if the input is positive
    if (n <= 0) {
        printf("Please enter a positive integer.\n");
        return 1; // Exit the program if input is invalid
    }

    // Calculate the sum from 1 to n
    for (i = 1; i <= n; i++) {
        sum = sum + i;
    }

    // Display the result
    printf("Sum of numbers from 1 to %d is: %d\n", n, sum);

    return 0;
}
