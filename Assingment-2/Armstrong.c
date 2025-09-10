// Q: How do we check if a number is an Armstrong number?

#include <stdio.h>

int main() {
    int number, org, sum = 0, digit;

    // Input: Read a positive integer
    printf("Enter a positive integer: ");
    scanf("%d", &number);

    org = number; // Save the original number

    // Process each digit
    while (number > 0) {
        digit = number % 10;               // Extract last digit
        sum += digit * digit * digit;      // Add cube of the digit to sum
        number /= 10;                       // Remove last digit
    }

    // Check if sum equals the original number
    if (sum == org) {
        printf("%d is an Armstrong number.\n", org);
    } else {
        printf("%d is not an Armstrong number.\n", org);
    }

    return 0;
}
