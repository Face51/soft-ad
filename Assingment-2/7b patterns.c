// Q: Write a program to print the following pattern for n rows
#include <stdio.h>

int main() {
    int n, i, j;

    printf("Enter number range : ");
    scanf("%d", &n);

    // Outer loop for rows
    for(i = 1; i <= n; i++, printf("\n")) {
        // Inner loop to print numbers
        for(j = 1; j <= i; j++) {
            printf("%d", i);
        }
    }

    return 0;
}
