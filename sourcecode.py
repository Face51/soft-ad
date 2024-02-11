import random

# Dictionary of words, hints, and categories
words_and_hints = {
    # Colors
    'red': 'The color of blood and fire.',
    'blue': 'The color of the sky and ocean.',
    'green': 'The color of grass and leaves.',
    'yellow': 'The color of sunshine and bananas.',
    'orange': 'The color of carrots and pumpkins.',
    'purple': 'The color associated with royalty and magic.',
    'pink': 'The color often associated with romance and sweetness.',

    # Flowers
    'rose': 'A popular flower known for its beauty and fragrance.',
    'daisy': 'A small flower with white petals and a yellow center.',
    'tulip': 'A bulbous spring-flowering plant with colorful cup-shaped flowers.',
    'sunflower': 'A tall plant with large, yellow, daisy-like flowers.',
    'lily': 'A fragrant flower with large, trumpet-shaped blooms.',
    'daffodil': 'A bright yellow flower with a trumpet-shaped central corona.',

    # Subjects
    'accountancy': 'The practice of recording, classifying, and analyzing financial transactions.',
    'economics': 'The study of how societies allocate scarce resources to satisfy unlimited wants and needs.',
    'physics': 'The branch of science concerned with the nature and properties of matter and energy.',
    'chemistry': 'The branch of science concerned with the composition, structure, and properties of matter.',
    'biology': 'The study of living organisms and their interactions with each other and their environments.',

    # General Knowledge
    'internet': 'A global network connecting millions of computers worldwide.',
    'democracy': 'A system of government in which the citizens exercise power through elected representatives.',
    'gravity': 'The force that attracts two bodies toward each other.',
    'evolution': 'The process by which species of organisms arise and develop through natural selection.',
    'climate': 'The long-term pattern of weather conditions in a particular area.',
    'solar': 'Relating to or determined by the sun.',
    'emission': 'The production and discharge of something, especially gas or radiation.',
    'equator': 'An imaginary line drawn around the earth equally distant from both poles.',
    'eclipse': 'An obscuring of the light from one celestial body by the passage of another between it and the observer.',
    'tornado': 'A mobile, destructive vortex of violently rotating winds having the appearance of a funnel-shaped cloud and advancing beneath a large storm system.',

    # Accountancy Keywords
    'balance': 'The difference between the debits and credits in an account.',
    'audit': 'A systematic examination of financial records and documents.',
    'ledger': 'A book or computer program containing accounts in which transactions are recorded.',
    'profit': 'The financial gain made in a transaction or business venture.',
    'loss': 'The financial result of a transaction or business venture resulting in negative earnings.',

    # Economics Keywords
    'supply': 'The amount of a good or service that producers are willing and able to sell at a given price.',
    'demand': 'The quantity of a good or service that consumers are willing and able to buy at a given price.',
    'market': 'A place where buyers and sellers come together to exchange goods and services.',
    'inflation': 'A general increase in prices and fall in the purchasing value of money.',
    'unemployment': 'The state of being without a paid job but available to work and actively seeking employment.',
}

# Function to choose a random word and its hint
def choose_word_and_hint(words_and_hints):
    word, hint = random.choice(list(words_and_hints.items()))
    return word, hint

# Function to play the game
def play_game():
    word, hint = choose_word_and_hint(words_and_hints)
    guessed_letters = []
    attempts = 7

    print("\033[1;35;40m╔════════════════════════════╗\033[0m")
    print("\033[1;35;40m║      Welcome to Word       ║\033[0m")
    print("\033[1;35;40m║    Guessing Game!🎮        ║\033[0m")
    print("\033[1;35;40m╚════════════════════════════╝\033[0m")

    print("\033[1;32;40mHere's a hint:\033[0m")
    print("\033[1;36;40m", hint, "\033[0m")

    print("\033[1;34;40mTry to guess the word. You have 7 attempts.\033[0m")

    while attempts > 0:
        display_word = ' '.join([f"\033[4m{_}\033[0m" if _ in guessed_letters else '_' for _ in word])
        print("\n\033[1;33;40mWord: \033[0m", display_word)

        if '_' not in display_word:
            print("\n\033[1;32;40mCongratulations! You guessed the word correctly:\033[0m", word)
            break

        guess = input("\n\033[1;34;40mEnter a letter: \033[0m").lower()

        if len(guess) != 1 or not guess.isalpha():
            print("\n\033[1;31;40mPlease enter a single letter.\033[0m")
            continue

        if guess in guessed_letters:
            print("\n\033[1;31;40mYou've already guessed that letter.\033[0m")
            continue

        guessed_letters.append(guess)

        if guess not in word:
            attempts -= 1
            print("\n\033[1;31;40mIncorrect guess. You have", attempts, "attempts left.\033[0m")

    else:
        print("\n\033[1;31;40mSorry, you've run out of attempts. The word was:\033[0m", word)

# Play the game
play_game()
