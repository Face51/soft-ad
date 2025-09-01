#include <stdio.h>

int main() {
    int num1, num2, num3, num4;
    int max, min;

    // Input: four numbers
printf("Enter four numbers: ");
scanf("%d %d %d %d", &num1, &num2, &num3, &num4);

    // Determine maximum
    max = num1;
    if (num2 > max) max = num2;
    if (num3 > max) max = num3;
    if (num4 > max) max = num4;

    // Determine minimum
    min = num1;
    if (num2 < min) min = num2;
    if (num3 < min) min = num3;
    if (num4 < min) min = num4;

    // Output result
    printf("\nGreatest = %d", max);
    printf("\nSmallest = %d", min);

    return 0;
}

