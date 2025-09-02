#include <stdio.h>

int main() {
    int base, height, hypotenuse;
    int sqHypotenuse, sumOfSquares;

    // Input the sides of the triangle
    printf("Enter the Base of the Triangle: ");
    scanf("%d", &base);

    printf("Enter the Height of the Triangle: ");
    scanf("%d", &height);

    printf("Enter the Hypotenuse of the Triangle: ");
    scanf("%d", &hypotenuse);

    // Calculate squares
    sqHypotenuse = hypotenuse * hypotenuse;
    sumOfSquares = base * base + height * height;

    // Check right-angled condition
    if (sqHypotenuse == sumOfSquares) {
        printf("The Triangle is a Right-Angled Triangle.\n");
    } else {
        printf("The Triangle is NOT a Right-Angled Triangle.\n");
    }

    return 0;
}