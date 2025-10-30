#include <stdio.h>

// Function prototypes (only data types, no variable names)
int fact(int);
int gcd(int, int);
int reverse(int);
int prime(int);
int armstrong(int);

int main() {
    int ch, res, num, num1, num2;

    printf("1. To find factorial of a number.\n");
    printf("2. To find GCD of two numbers.\n");
    printf("3. To find reverse of a number.\n");
    printf("4. To check if a number is prime or not.\n");
    printf("5. To check if a number is Armstrong or not.\n");

    printf("Enter your choice: ");
    scanf("%d", &ch);

    switch (ch) {
        case 1:
            printf("Enter a number: ");
            scanf("%d", &num);
            res = fact(num);
            printf("The factorial is: %d\n", res);
            break;

        case 2:
            printf("Enter two numbers: ");
            scanf("%d %d", &num1, &num2);
            res = gcd(num1, num2);
            printf("The GCD is: %d\n", res);
            break;

        case 3:
            printf("Enter a number: ");
            scanf("%d", &num);
            res = reverse(num);
            printf("The reverse of the number is: %d\n", res);
            break;

        case 4:
            printf("Enter a number: ");
            scanf("%d", &num);
            res = prime(num);
            if (res == 1)
                printf("The number is prime.\n");
            else
                printf("The number is not prime.\n");
            break;

        case 5:
            printf("Enter a number: ");
            scanf("%d", &num);
            res = armstrong(num);
            if (res == 1)
                printf("The number is an Armstrong number.\n");
            else
                printf("The number is not an Armstrong number.\n");
            break;

        default:
            printf("Enter correct choice.\n");
    }

    return 0;
}

// Function definitions

int fact(int n) {
    int i, res = 1;
    if (n < 0)
        return 0; // Factorial not defined for negative numbers

    for (i = 1; i <= n; i++)
        res *= i;

    return res;
}

int gcd(int a, int b) {
    int temp;
    while (b != 0) {
        temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

int reverse(int n) {
    int rev = 0;
    while (n != 0) {
        rev = rev * 10 + n % 10;
        n /= 10;
    }
    return rev;
}

int prime(int n) {
    int i;
    if (n <= 1)
        return 0;

    for (i = 2; i <= n / 2; i++) {
        if (n % i == 0)
            return 0;
    }
    return 1;
}

int armstrong(int n) {
    int temp = n, sum = 0, digit;
    while (temp != 0) {
        digit = temp % 10;
        sum += digit * digit * digit;
        temp /= 10;
    }
    return (sum == n) ? 1 : 0;
}
