#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
    int i, n;
    int count = 0;
    int dice;

    printf("Enter number of trials: ");
    scanf("%d", &n);

    // Seed the random number generator
    srand(time(NULL));

    // Simulate rolling the dice
    for (i = 0; i < n; i++)
    {
        dice = rand() % 6 + 1;  // Generates number from 1 to 6

        if (dice == 5)
        {
            count++;
        }
    }

    // Calculate probability
    printf("\nNumber of times 5 occurred = %d", count);
    printf("\nEstimated Probability of getting 5 = %f\n",
           (float)count / n);

    return 0;
}



Enter number of trials: 6

Number of times 5 occurred = 1
Estimated Probability of getting 5 = 0.166667





