// Calculate standard deviation of given numbers

#include <stdio.h>
#include <math.h>

int main() {
    int n, i;
    float sum = 0.0, mean, var = 0.0, sd;

    printf("Enter number of elements: ");
    if (scanf("%d", &n) != 1 || n <= 0) {
        printf("Invalid size. Must be a positive integer.\n"); // Validate input
        return 1;
    }

    int arr[n];
    printf("Enter %d elements: ", n);
    for (i = 0; i < n; i++) {
        scanf("%d", &arr[i]);
    }

    // Calculate mean
    for (i = 0; i < n; i++)
        sum += arr[i];
    mean = sum / n;

    // Calculate variance
    for (i = 0; i < n; i++)
        var += pow(arr[i] - mean, 2);
    var /= n;

    // Calculate standard deviation
    sd = sqrt(var);

    printf("Standard deviation is = %.2f\n", sd);
    return 0;
}
