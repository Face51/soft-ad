#include <stdio.h>

int main() {
    const float pi = 3.14;
    float radius, area;

    // Input: radius of the circle
    printf("Enter the radius of the circle: ");
    scanf("%f", &radius);

    // Process: area = π * r²
    area = pi * radius * radius;

    // Output: display the result
    printf("Area of the circle is = %.2f\n", area);

    return 0;
}
