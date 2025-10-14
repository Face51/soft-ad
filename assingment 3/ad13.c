#include <stdio.h>

int main() {
    int n, i, search;
    int arr[10];        // Array of size 10

    // Input array elements
    printf("Enter %d elements:\n", n);
    for (i = 0; i < n; i++) {
        scanf("%d", &arr[i]);
    }
    //Input the element to search
    printf("Enter the element to search: ");
    scanf("%d", &search);

    //Linear search for the element
    for (i = 0; i < n; i++) {
        if (arr[i] == search) {
            printf("Element %d found at position %d.\n", search, i + 1);
            return 0;  // Exit immediately after finding
        }
    }
    //Element not found
    printf("Element %d not found in the array.\n", search);
    return 0;
}