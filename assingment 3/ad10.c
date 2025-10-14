// Count alphabets, digits, special characters, vowels, and consonants in a string
#include <stdio.h>
#include <ctype.h>  // for isalpha, isdigit, tolower

int main() {
    char str[1000];  // Array to store input string
    int i;
    int alphabets = 0, digits = 0, specialChars = 0;
    int vowels = 0, consonants = 0;

    printf("Enter a string: ");
    fgets(str, sizeof(str), stdin);  // Safe input including spaces

    // Count alphabets, digits, special characters, vowels, and consonants
    for (i = 0; str[i] != '\0'; i++) {
        char ch = str[i];

        if (isalpha(ch)) {
            alphabets++;
            ch = tolower(ch);
            if (ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u')
                vowels++;
            else
                consonants++;
        } else if (isdigit(ch)) {
            digits++;
        } else if (ch != ' ' && ch != '\n') {
            specialChars++;
        }
    }

    // Display results
    printf("Number of alphabets: %d\n", alphabets);
    printf("Number of digits: %d\n", digits);
    printf("Number of special characters: %d\n", specialChars);
    printf("Number of vowels: %d\n", vowels);
    printf("Number of consonants: %d\n", consonants);

    return 0;
}