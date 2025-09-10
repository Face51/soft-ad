// Q: How do we check if a number is an Armstrong number?

#include <stdio.h>
#include <math.h>

int main() {
    int number, org, sum = 0, digit, n = 0;

    // Input a positive integer
    printf("Enter a positive integer: ");
    scanf("%d", &number);

    // Validate input
    if (number <= 0) {
        printf("Please enter a positive integer.\n");
        return 1;
    }

    org = number;
    int temp = number;

    // Count the number of digits
    while (temp) {
        temp /= 10;
        n++;
    }

    temp = org;

    // Calculate sum of digits raised to power n
    while (temp) {
        digit = temp % 10;
        sum += pow(digit, n);
        temp /= 10;
    }

    // Check and print result
    printf("%d is %san Armstrong number.\n", org, (sum == org) ? "" : "not ");

    return 0;
}
