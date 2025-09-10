// Q: How do we check if a number is a palindrome

#include <stdio.h>

int main() {
    int n, org, reverse = 0, digit;

    // Input: Get a non-negative integer from the user
    printf("Enter a non-negative integer: ");
    scanf("%d", &n);

    // Validate input
    if (n < 0) {
        printf("Please enter a non-negative integer.\n");
        return 1;
    }

    org = n; // Store original number for later comparison

    // Reverse the number
    while (n > 0) {
        digit = n % 10;                    // Extract last digit
        reverse = reverse * 10 + digit;    // Append digit to reversed number
        n /= 10;                           // Remove last digit
    }

    // Check if reversed number is equal to original
    if (org == reverse) {
        printf("%d is a palindrome.\n", org);
    } else {
        printf("%d is not a palindrome.\n", org);
    }

    return 0;
}
