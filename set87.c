#include <stdio.h>

// Function prototype
void inputSet(int set[], int size, char setName);

int main() {
    int setA[100], setB[100], setC[200];
    int sizeA, sizeB, sizeC = 0;
    int i, j;

    // Input Set A
    printf("Enter size of Set A: ");
    scanf("%d", &sizeA);
    inputSet(setA, sizeA, 'A');

    // Input Set B
    printf("\nEnter size of Set B: ");
    scanf("%d", &sizeB);
    inputSet(setB, sizeB, 'B');

    // Copy all elements of Set A into Set C
    for (i = 0; i < sizeA; i++) {
        setC[sizeC++] = setA[i];
    }

    // Add elements from Set B if not already in Set A
    for (i = 0; i < sizeB; i++) {
        for (j = 0; j < sizeA; j++) {
            if (setB[i] == setA[j])
                break;
        }
        if (j == sizeA) { // Element not found → unique
            setC[sizeC++] = setB[i];
        }
    }

    // Display final union set
    printf("\nUnion of Set A and Set B is: { ");
    for (i = 0; i < sizeC; i++) {
        printf("%d", setC[i]);
        if (i < sizeC - 1)
            printf(", ");
    }
    printf(" }\n");

    return 0;
}

// Function to input set elements with duplicate check
void inputSet(int set[], int size, char setName) {
    int i, j;
    printf("Enter elements of Set %c:\n", setName);
    for (i = 0; i < size; i++) {
        printf("Element %d: ", i + 1);
        scanf("%d", &set[i]);

        // Check for duplicates in same set
        for (j = 0; j < i; j++) {
            if (set[i] == set[j]) {
                printf("Duplicate found! Enter a different value.\n");
                i--;
                break;
            }
        }
    }
}