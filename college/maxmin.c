#include <stdio.h>

int main() {
    int num1, num2, num3, num4;
    int max, min;

    // Input: four numbers
    printf("Enter first number: ");
    scanf("%d", &num1);

    printf("Enter second number: ");
    scanf("%d", &num2);

    printf("Enter third number: ");
    scanf("%d", &num3);

    printf("Enter fourth number: ");
    scanf("%d", &num4);

    // Determine maximum
    if (num1 >= num2 && num1 >= num3 && num1 >= num4)
        max = num1;
    else if (num2 >= num1 && num2 >= num3 && num2 >= num4)
        max = num2;
    else if (num3 >= num1 && num3 >= num2 && num3 >= num4)
        max = num3;
    else
        max = num4;

    // Determine minimum
    if (num1 <= num2 && num1 <= num3 && num1 <= num4)
        min = num1;
    else if (num2 <= num1 && num2 <= num3 && num2 <= num4)
        min = num2;
    else if (num3 <= num1 && num3 <= num2 && num3 <= num4)
        min = num3;
    else
        min = num4;

    // Output result
    printf("\nGreatest = %d", max);
    printf("\nSmallest = %d", min);

    return 0;
}
