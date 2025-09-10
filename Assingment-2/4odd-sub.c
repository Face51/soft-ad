// Q: program to find the sum of first n natural numbers (add odd, subtract even)

#include <stdio.h>

int main() {
    int n, i, sum = 0;

    // Input a positive integer
    printf("Enter a Range: ");
    scanf("%d", &n);

    // Add odd numbers and subtract even numbers to n
    for (i = 1; i <= n; i++) {
        if (i % 2 == 0)
            sum = sum - i; // Subtract if even
        else
            sum = sum + i; // Add if odd
    }

    // Display the result
    printf("The result is %d\n", sum);

    return 0;
}
