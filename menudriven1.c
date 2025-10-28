#include <stdio.h>
#include <math.h>

// Function prototypes
int fact(int n);
int gcd(int a, int b);
int reverse(int n);
int prime(int n);
int armstrong(int n);

int main() {
    int ch, res, num, num1, num2;

    printf("1. To find factorial of a number.\n");
    printf("2. To find GCD of two numbers.\n");
    printf("3. To find reverse of a number.\n");
    printf("4. To check whether a number is prime or not.\n");
    printf("5. To check whether a number is Armstrong or not.\n");

    printf("Enter your choice: ");
    scanf("%d", &ch);

    // switch case starts
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
            printf("The reverse number is: %d\n", res);
            break;

        case 4:
            printf("Enter a number: ");
            scanf("%d", &num);
            res = prime(num);
            if (res)
                printf("The number is prime.\n");
            else
                printf("The number is not prime.\n");
            break;

        case 5:
            printf("Enter a number: ");
            scanf("%d", &num);
            res = armstrong(num);
            if (res)
                printf("The number is Armstrong.\n");
            else
                printf("The number is not Armstrong.\n");
            break;

        default:
            printf("Enter correct choice.\n");
    }

    return 0;
}

// ------------------- Function Definitions -------------------

int fact(int n) {
    int i, res = 1;
    if (n < 0)
        return 0; // factorial not defined for negative numbers
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
    if (n <= 1)
        return 0;
    for (int i = 2; i <= n / 2; i++) {
        if (n % i == 0)
            return 0;
    }
    return 1;
}

int armstrong(int n) {
    int rem, sum = 0, temp = n, digits = 0;
    while (temp != 0) {
        digits++;
        temp /= 10;
    }
    temp = n;
    while (temp != 0) {
        rem = temp % 10;
        sum += pow(rem, digits);
        temp /= 10;
    }
    return (sum == n);
}
