// Q: How do we check if a number is a palindrome?

#include <stdio.h>

int main() {
    int n, original, reverse = 0, digit;

    // Input: Get a number from the user
    printf("Enter a number: ");
    scanf("%d", &n);

    original = n; // Store original number for later comparison

    // Reverse the number
    while (n > 0) {
        digit = n % 10;            // Extract last digit
        reverse = reverse * 10 + digit; // Append digit to reversed number
        n /= 10;                   // Remove last digit
    }

    // Check if reversed number is equal to original
    if (original == reverse) {
        printf("%d is a palindrome.\n", original);
    } else {
        printf("%d is not a palindrome.\n", original);
    }

    return 0;
}
