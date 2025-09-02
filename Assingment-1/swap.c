#include <stdio.h>

int main() {
    int num1, num2;

    // Input two numbers
    printf("Enter First Number: ");
    scanf("%d", &num1);

    printf("Enter Second Number: ");
    scanf("%d", &num2);

    // Display before swapping
    printf("\nBefore Swapping:\nFirst Number = %d, Second Number = %d\n", num1, num2);

    // Swap numbers (without using a temporary variable)
    num1 = num1 + num2;
    num2 = num1 - num2;
    num1 = num1 - num2;

    // Display after swapping
    printf("After Swapping:\nFirst Number = %d, Second Number = %d\n", num1, num2);

    return 0;
}
