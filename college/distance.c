#include <stdio.h>
#include <math.h>

int main() {
    int x1, y1, x2, y2;
    float distance;

    // Input coordinates
    printf("Enter x1, y1, x2, y2: ");
    scanf("%d %d %d %d", &x1, &y1, &x2, &y2);

    // Calculate and display Euclidean distance
    distance = sqrt((x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1));
    printf("Euclidean Distance = %.2f units\n", distance);

    return 0;
}
