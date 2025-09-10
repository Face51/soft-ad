// Q: How do we check if a number is a Krishnamurthy (Strong) number?

#include <stdio.h>

int main() {
    int number, org, sum = 0, digit, fact, i;

    // Input: Read a positive integer
    printf("Enter a positive integer: ");
    scanf("%d", &number);

    // Validate input
    if (number <= 0) {
        printf("Please enter a positive integer.\n");
        return 1;
    }

    org = number; // Save original number for later comparison

    // Process each digit
    while (number > 0) {
        digit = number % 10; // Get last digit
        fact = 1;

        // Calculate factorial of the digit
        for (i = 1; i <= digit; i++) {
            fact *= i;
        }

        sum += fact;      // Add factorial to sum
        number /= 10;     // Remove last digit
    }

    // Check if sum equals the original number
    if (sum == org) {
        printf("%d is a Krishnamurthy number.\n", org);
    } else {
        printf("%d is not a Krishnamurthy number.\n", org);
    }

    return 0;
}
