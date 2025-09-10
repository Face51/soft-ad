// Q: How do we print a triangle pattern of stars?

#include <stdio.h>

int main()
{
    int n, i, j;

    // Input number of rows
    printf("Enter number of rows: ");
    scanf("%d", &n);

    // Outer loop for rows
    for(i = 1; i <= n; i++)
    {
        // Inner loop to print stars in each row
        for(j = 1; j <= i; j++)
        {
            printf("*");
        }
        printf("\n"); // Move to next row
    }

    return 0;
}
