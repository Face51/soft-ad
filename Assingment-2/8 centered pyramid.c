// Q: How do we print a centered pyramid of stars

#include <stdio.h>

int main() {
    int n, i, j;

    // Input number of rows
    printf("Enter number of rows: ");
    scanf("%d", &n);

    // Check if input is positive
    if (n <= 0) {
        printf("Please enter a positive integer.\n");
        return 1; // Exit if input is invalid
    }

    // Loop for each row
    for(i = 1; i <= n; i++) {
        // Print spaces before stars
        for(j = 1; j <= n - i; j++) {
            printf(" ");
        }
        // Print stars: 2*i - 1 stars in each row
        for(j = 1; j <= 2 * i - 1; j++) {
            printf("*");
        }
        printf("\n"); // Move to the next row
    }

    return 0;
}
