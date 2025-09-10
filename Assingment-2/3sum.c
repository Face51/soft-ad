// Q: program to find the sum of first n natural numbers

#include <stdio.h>

int main() {
    int n, i, sum = 0;

    // Input a positive integer
    printf("Enter a Range: ");
    scanf("%d", &n);

    // Calculate the sum to n
    for (i = 1; i <= n; i++) {
        sum = sum + i;
    }

    // Display the result
    printf("Sum of numbers from 1 to %d is: %d\n", n, sum);

    return 0;
}
