// Q: program to print the Fibonacci series up to n terms

#include <stdio.h>

int main() {
    int n, i;
    int a = 0, b = 1, next;

    // Input the number of terms
    printf("Enter the number of terms: ");
    scanf("%d", &n);

    printf("Fibonacci series: ");

    // Generate and print the Fibonacci sequence
    for (i = 1; i <= n; i++) {
        printf("%d ", a);
        next = a + b; // Calculate next term
        a = b;        // Move forward in the sequence
        b = next;
    }

    printf("\n");
    return 0;
}
