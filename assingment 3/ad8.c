// Split an array into even and odd position arrays  
#include <stdio.h>

int main() {
    int n, i;
    int arr[100], evenArray[100], oddArray[100];
    int evenCount = 0, oddCount = 0;

    printf("Enter number of elements: ");
    scanf("%d", &n);

    printf("Enter %d elements: ", n);
    for (i = 0; i < n; i++) {
        scanf("%d", &arr[i]);

        // Separate elements into even and odd positions
        if (i % 2 == 0)
            evenArray[evenCount++] = arr[i];
        else
            oddArray[oddCount++] = arr[i];
    }

    // Print elements at even positions
    printf("\nElements at even positions: ");
    for (i = 0; i < evenCount; i++)
        printf("%d ", evenArray[i]);

    // Print elements at odd positions
    printf("\nElements at odd positions: ");
    for (i = 0; i < oddCount; i++)
        printf("%d ", oddArray[i]);

    return 0;
}