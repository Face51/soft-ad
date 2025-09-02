#include <stdio.h>

int main() {
    float units, amount;

    // Input: units consumed
    printf("Enter the Units Consumed: ");
    scanf("%f", &units);

    // Error handling for invalid input
    if (units < 0) {
        printf("Units Invalid\n");
    }
    // Base charge for first 50 units
    else if (units <= 50) {
        amount = 100;
    }
    // Next 50 units (51–100) charged @ 0.80/unit
    else if (units <= 100) {
        amount = 100 + (units - 50) * 0.80;
    }
    // Next 200 units (101–300) charged @ 1.20/unit
    else if (units <= 300) {
        amount = 100 + (50 * 0.80) + (units - 100) * 1.20;
    }
    // Above 300 units charged @ 1.50/unit
    else {
        amount = 100 + (50 * 0.80) + (200 * 1.20) + (units - 300) * 1.50;
    }

    // Final output
    printf("Electricity Bill is: Rs. %.2f\n", amount);

    return 0;
}
