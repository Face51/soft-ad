#include<stdio.h>
//Declaring prototype
int fact();
int gcd();
int reverse();
int prime();
int armstrong();

int main()
{
	int ch,res,num1,num2;
	printf("1. To find factorial of a number.");
	printf("2. To find GCD of a number.");
	printf("3. To find reverse of a number.");
	printf("4. To find number is prime or not.");
	printf("5. To find number is armstrtong or not.");

	printf("Enter corresponding number of your choice.");
	scanf("%d",&ch);
	//starting of switch case
	switch(ch)
	{
	
		case 1:
			res=fact();
			printf("The factorial is: %d",res);
			break;
		case 2:
			res=gcd();
			printf("The GCD is: %d",res);
			break;
		case 3:
			res=reverse();
			printf("The reverse order is: %d",res);
			break;
		case 4:
			res=prime();
			printf("%d",res);
			break;
		case 5:
			res=armstrong();
			printf("%d",res);
			break;
		default:
			printf("Enter correct choice.");
	}
	return 0;
}
int fact()
{
	int i,n;
	int res;
	if(n<0)
		printf("number is negative");
	for (i = 1; i <= n; i++) {
            res=res * i;
        }
	printf("%d",res);
}
int gcd()
{
	int x,y,res;
    while (y != 0) {
        int temp = y;
        y = x % y;
        x = temp;
    }
    res = x;
}