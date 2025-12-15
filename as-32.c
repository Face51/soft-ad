#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define RED 1
#define BLUE 2
#define GREEN 3

int draw_ball()
{
    int r = rand() % 10 + 1;

    if (r <= 4)
        return RED;
    else if (r <= 7)
        return BLUE;
    else
        return GREEN;
}

int main()
{
    int num_trials = 10000;
    int red_count = 0, blue_count = 0, green_count = 0;
    int i, drawn_ball;

    srand(time(NULL));

    for (i = 0; i < num_trials; i++)
    {
        drawn_ball = draw_ball();

        if (drawn_ball == RED)
            red_count++;
        else if (drawn_ball == BLUE)
            blue_count++;
        else
            green_count++;
    }

    double red_prob = (double)red_count / num_trials;
    double blue_prob = (double)blue_count / num_trials;
    double green_prob = (double)green_count / num_trials;

    printf("Red ball count = %d, Observed probability = %.4f\n", red_count, red_prob);
    printf("Blue ball count = %d, Observed probability = %.4f\n", blue_count, blue_prob);
    printf("Green ball count = %d, Observed probability = %.4f\n", green_count, green_prob);

    return 0;
}



Red ball count = 3970, Observed probability = 0.3970
Blue ball count = 3007, Observed probability = 0.3007
Green ball count = 3023, Observed probability = 0.3023
