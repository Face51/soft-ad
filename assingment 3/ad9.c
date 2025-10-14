// Count vowels and consonants in a string  
#include <stdio.h>
#include <ctype.h>  // for tolower()
#include <string.h> // for strlen()

int main() {
    char str[100];       // Fixed-size array for input
    int vowels = 0, consonants = 0;

    printf("Enter a string: ");
    fgets(str, sizeof(str), stdin);       // Safe input including spaces

    str[strcspn(str, "\n")] = '\0';       // Remove newline if present

    // Count vowels and consonants
    for (int i = 0; str[i] != '\0'; i++) {
        char ch = tolower(str[i]);
        if (ch >= 'a' && ch <= 'z') {
            (ch=='a'||ch=='e'||ch=='i'||ch=='o'||ch=='u') ? vowels++ : consonants++;
        }
    }

    // Display counts
    printf("Number of vowels: %d\n", vowels);
    printf("Number of consonants: %d\n", consonants);

    return 0;
}