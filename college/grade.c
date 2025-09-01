#include <stdio.h>

int main() {
    int marks;

    // Input marks
    printf("Enter your marks: ");
    scanf("%d", &marks);

    // Determine grade
    if (marks >= 90 && marks <= 100) {
        printf("Grade: O\n");
    } else if (marks >= 80 && marks < 90) {
        printf("Grade: E\n");
    } else if (marks >= 70 && marks < 80) {
        printf("Grade: A\n");
    } else if (marks >= 60 && marks < 70) {
        printf("Grade: B\n");
    } else if (marks >= 50 && marks < 60) {
        printf("Grade: C\n");
    } else if (marks >= 40 && marks < 50) {
        printf("Grade: D\n");
    } else if (marks < 40 && marks >= 0) {
        printf("Grade: F\n");
    } else {
        printf("Invalid marks entered.\n");
    }

    return 0;
}
