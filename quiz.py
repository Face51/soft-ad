import random


def run_quiz(questions):
    # Shuffle the questions and select 5 random questions
    question_keys = list(questions.keys())
    random.shuffle(question_keys)
    selected_questions = {key: questions[key] for key in question_keys[:5]}

    score = 0

    for i, (question, correct_answer) in enumerate(selected_questions.items(), 1):
        print(f"Question {i}: {question}")
        user_answer = input("Your answer: ").strip().lower()

        if user_answer == correct_answer:
            score += 1

    return score


# Dictionary to store questions and answers
quiz_questions = {
    "What is the capital of India?": "new delhi",
    "Who is the first Prime Minister of India?": "jawaharlal nehru",
    "What is the national flower of India?": "lotus",
    "Which mountain range is located in northern India?": "himalayas",
    "Who is known as the 'Iron Man of India'?": "sardar vallabhbhai patel",
    "Who is the father of modern economics?": "adam smith",
    "What is the basic economic problem?": "scarcity",
    "What is the study of production, consumption, and transfer of wealth?": "economics",
    "What is the branch of economics that deals with the economy as a whole?": "macroeconomics",
    "What is the branch of economics that deals with individual units in the economy?": "microeconomics",
    "What is the process of analyzing, summarizing, and communicating financial transactions?": "accounting",
    "What is the process of planning, organizing, directing, and controlling financial activities?": "finance"
}

# Run the quiz once
print("Welcome to the Quiz!")
print("Let's begin:\n")
total_score = run_quiz(quiz_questions)

# Display the total score
print(f"\nTotal score: {total_score}/5")
