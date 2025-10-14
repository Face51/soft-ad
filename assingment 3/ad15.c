#include <stdio.h>
#include <math.h>

int main() {
    int arr[] = {1, 2, 3, 4, 5};
    int n = 5, i;
    float sum = 0.0, mean, var = 0.0, sd;

    // Calculate mean
    for(i = 0; i < n; i++)
        sum += arr[i];
    mean = sum / n;

    // Calculate variance
    for(i = 0; i < n; i++)
        var += pow(arr[i] - mean, 2);
    var /= n;

    // Calculate standard deviation
    sd = sqrt(var);

    printf("Standard deviation is = %.2f\n", sd);
    return 0;
}
