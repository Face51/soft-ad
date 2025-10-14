#include <stdio.h>

int main() {
    int arr[] = {10, 30, 90, 45};  // Array of integers

    // Calculate number of elements
    int numberOfElements = sizeof(arr) / sizeof(arr[0]);

    printf("Size of the array is: %d\n", numberOfElements);
    return 0;
}
