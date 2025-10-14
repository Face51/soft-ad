#include <stdio.h>

int main() {
    int n, i, max, min;
    float sum = 0, average;

    // Input array size
   printf("Enter number of elements: ");
    if (scanf("%d", &n) != 1 || n <= 0) {
        printf("Invalid size. Must be a positive integer.\n");
        return 1;
    }
    int arr[n];          
    
    // Input array elements
    printf("Enter %d elements:\n", n);
    for(i = 0; i < n; i++) {
        scanf("%d", &arr[i]);
    }

    // Initialize max and min 
    max = min = arr[0];

    // Traverse array to find max, min and sum
    for(i = 0; i < n; i++) {
        if(arr[i] > max) max = arr[i];
        if(arr[i] < min) min = arr[i];
        sum += arr[i];
    }

    // Calculate average
    average = sum / n;
    printf("Max = %d\nMin = %d\nAverage = %.2f\n", max, min, average);

    return 0;
}