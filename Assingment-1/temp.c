#include <stdio.h>

int main() {
    float fahrenheit, celsius;

    // Input temperature in Fahrenheit
    printf("Enter temperature in Fahrenheit: ");
    scanf("%f", &fahrenheit);

    // Convert to Celsius
    celsius = (fahrenheit - 32) * 5.0 / 9.0;

    // Display result
    printf("Temperature in Celsius = %.2f\n", celsius);

    return 0;
}
