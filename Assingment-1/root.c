#include <stdio.h>
#include <math.h>

int main() {
    int a, b, c;
    float discriminant, root1, root2, realPart, imagPart;

    // Input coefficients
    printf("Enter the Coefficient of x^2: ");
    scanf("%d", &a);

    printf("Enter the Coefficient of x: ");
    scanf("%d", &b);

    printf("Enter the Constant: ");
    scanf("%d", &c);

    printf("\nThe Quadratic Equation is: %dx^2 + %dx + %d\n", a, b, c);

    // Calculate discriminant
    discriminant = (b * b) - (4 * a * c);

    if (discriminant > 0) {
        // Two distinct real roots
        root1 = (-b + sqrt(discriminant)) / (2 * a);
        root2 = (-b - sqrt(discriminant)) / (2 * a);
        printf("Roots are real and distinct.\n");
        printf("Roots: %.2f and %.2f\n", root1, root2);
    }
    else if (discriminant == 0) {
        // One real root (repeated)
        root1 = -b / (2.0 * a);
        printf("Roots are real and equal.\n");
        printf("Root: %.2f and %.2f\n", root1, root1);
    }
    else {
        // Imaginary roots
        realPart = -b / (2.0 * a);
        imagPart = sqrt(-discriminant) / (2 * a);
        printf("Roots are imaginary.\n");
        printf("Roots: %.2f + %.2fi and %.2f - %.2fi\n", realPart, imagPart, realPart, imagPart);
    }

    return 0;
}