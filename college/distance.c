#include <stdio.h>
#include <math.h>

int main() {
    int x1, y1, x2, y2;
    float distance;

    // Input coordinates
    printf("Enter the x-coordinate of Point 1: ");
    scanf("%d", &x1);
    printf("Enter the y-coordinate of Point 1: ");
    scanf("%d", &y1);
    printf("Enter the x-coordinate of Point 2: ");
    scanf("%d", &x2);
    printf("Enter the y-coordinate of Point 2: ");
    scanf("%d", &y2);

    // Calculate Euclidean Distance
    distance = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));

    // Display result
    printf("The Euclidean Distance between Point 1 and Point 2 is = %.2f units\n", distance);

    return 0;
}
