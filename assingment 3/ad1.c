// Count even and odd numbers in an array
#include <stdio.h>

int main() {
    int n, i, even_count = 0, odd_count = 0;

    printf("Enter number of elements: ");
    if (scanf("%d", &n) != 1 || n <= 0) {
        printf("Invalid size. Must be a positive integer.\n");// Validate input
        return 1;
    }
    int arr[n];
    printf("Enter %d elements: ", n);
    for (i = 0; i < n; i++) {
        scanf("%d", &arr[i]);
        (arr[i] % 2 == 0) ? even_count++ : odd_count++;// Update counts
    }
    
    printf("Even numbers: %d\n",even_count);
    printf("Odd numbers: %d\n",odd_count);
    return 0;
}