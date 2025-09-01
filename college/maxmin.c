#include <stdio.h>

int main() {
    int num1, num2, num3, max, min;

    // Input three numbers
    printf("Enter three numbers: ");
    scanf("%d %d %d", &num1, &num2, &num3);

    // Find maximum
    max = num1;
    if (num2 > max) max = num2;
    if (num3 > max) max = num3;

    // Find minimum
    min = num1;
    if (num2 < min) min = num2;
    if (num3 < min) min = num3;

    // Display results
    printf("Maximum number is: %d\n", max);
    printf("Minimum number is: %d\n", min);

    return 0;
}
