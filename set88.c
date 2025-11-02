#include <stdio.h>

// Function declarations
void inputSet(int set[], int size, char setName);
int isPresent(int set[], int size, int element);

int main() {
    int setA[100], setB[100], setC[100];
    int sizeA, sizeB, sizeC = 0;
    int i,j;
    //input setA
    printf("Enter number of elements in Set A: ");
    scanf("%d", &sizeA);
    inputSet(setA, sizeA, 'A');

    //input setB
    printf("\nEnter number of elements in Set B: ");
    scanf("%d", &sizeB);
    inputSet(setB, sizeB, 'B');

    // Finding Difference A - B
    for (i = 0; i < sizeA; i++) {
        if (!isPresent(setB, sizeB, setA[i])) {
            setC[sizeC++] = setA[i];
        }
    }

    // Display result
    printf("\nSet Difference (A - B): { ");
    if (sizeC == 0) {
        printf("Empty Set ");
    } else {
        for ( i = 0; i < sizeC; i++) {
            printf("%d", setC[i]);
            if (i < sizeC - 1)
                printf(", ");
        }
    }
    printf("}\n");

    return 0;
}

// Function to input elements of a set
void inputSet(int set[], int size, char setName) {
    int i, j;
    printf("\nEnter elements of Set %c:\n", setName);
    for (int i = 0; i < size; i++) {
        printf("Element %d: ", i + 1);
        scanf("%d", &set[i]);

        // Check for duplicate
        for (int j = 0; j < i; j++) {
            if (set[i] == set[j]) {
                printf("Duplicate! Please enter a different number.\n");
                i--;
                break;
            }
        }
    }
}

// Function to check if an element is present in a set
int isPresent(int set[], int size, int element) {
    for (int i = 0; i < size; i++) {
        if (set[i] == element)
            return 1;   // Found
    }
    return 0;           // Not found
}