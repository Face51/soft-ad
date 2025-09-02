#include <stdio.h>

int main() {
    int marks;

    // Input marks from the user
    printf("Enter the marks: ");
    scanf("%d", &marks);

    // Grade assignment based on marks range
    if (marks >= 90 && marks <= 100) {
        printf("\nMarks = %d, Grade = O\n", marks);
    } 
    else if (marks >= 80) {
        printf("\nMarks = %d, Grade = E\n", marks);
    } 
    else if (marks >= 70) {
        printf("\nMarks = %d, Grade = A\n", marks);
    } 
    else if (marks >= 60) {
        printf("\nMarks = %d, Grade = B\n", marks);
    } 
    else if (marks >= 50) {
        printf("\nMarks = %d, Grade = C\n", marks);
    } 
    else if (marks >= 40) {
        printf("\nMarks = %d, Grade = D\n", marks);
    } 
    else if (marks >= 0) {
        printf("\nMarks = %d, Grade = F\n", marks);
    } 
    else {
        // Invalid input case
        printf("\nINVALID INPUT! Marks should be between 0 and 100.\n");
    }

    return 0;
}
