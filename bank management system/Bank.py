import mysql.connector
from mysql.connector import Error
import random

# Database connection details
DB_HOST = 'localhost'
DB_NAME = 'bankdb'
DB_USER = 'root'
DB_PASSWORD = 'pass'


# Function to connect to the database
def connect():
    try:
        return mysql.connector.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
    except Error as e:
        print("Error connecting to the database.")
        return None


# Function to run SQL queries
def execute_query(query, *args, fetch_all=False):
    conn = connect()
    if conn is None:
        return None

    cursor = conn.cursor()
    try:
        cursor.execute(query, args)
        result = cursor.fetchall() if fetch_all else True
        conn.commit()
        return result
    except mysql.connector.Error as e:
        print("Error executing query:", e)
        return None
    finally:
        cursor.close()
        conn.close()


# Function to create a new account
def create_account():
    try:
        # Generate a new account number
        new_acc_no = '3366810000' + str(random.randint(1000, 9999))
        name = input("Enter the account holder's name: ").strip()
        acc_type = input("Enter the type of account (C/S): ").strip().upper()
        if acc_type not in ('C', 'S'):
            raise ValueError("Invalid input. Please enter C for Current or S for Savings.")
        deposit = float(input("Enter the initial deposit (>=500 for Savings and >=1000 for Current): "))
        if (acc_type == 'S' and deposit < 500) or (acc_type == 'C' and deposit < 1000):
            raise ValueError("Invalid deposit amount.")

        query = "INSERT INTO accounts (accNo, name, accType, deposit) VALUES (%s, %s, %s, %s)"
        if execute_query(query, new_acc_no, name, acc_type, deposit):
            print(f"Account created successfully! Your account number is {new_acc_no}")
    except ValueError as ve:
        print(str(ve))


# Function to display account details using last 4 digits
def display_account(last_4_digits):
    query = "SELECT * FROM accounts WHERE accNo LIKE %s"
    accounts = execute_query(query, f'%{last_4_digits}', fetch_all=True)
    if accounts:
        for account in accounts:
            print(f"Account Number: {account[0]}, Account Holder Name: {account[1]}, "
                  f"Type of Account: {account[2]}, Balance: {account[3]}")
    else:
        print("No account found with the provided last 4 digits.")


# Function to deposit or withdraw money using the last 4 digits of the account number
def deposit_or_withdraw(last_4_digits, amount, action):
    query = "SELECT accNo, deposit FROM accounts WHERE accNo LIKE %s"
    accounts = execute_query(query, f'%{last_4_digits}', fetch_all=True)
    if not accounts:
        print("No account found with the provided last 4 digits.")
        return

    accNo = accounts[0][0]
    balance = accounts[0][1]

    if action == "deposit":
        query = "UPDATE accounts SET deposit = deposit + %s WHERE accNo = %s"
        message = "Deposit"
    elif action == "withdraw" and balance >= amount:
        query = "UPDATE accounts SET deposit = deposit - %s WHERE accNo = %s"
        message = "Withdrawal"
    else:
        print("Insufficient balance.")
        return

    if execute_query(query, amount, accNo):
        print(f"{message} successful!")
    else:
        print(f"Failed to {action} amount.")


# Function to delete an account using the last 4 digits
def delete_account():
    try:
        last_4_digits = input("Enter the last 4 digits of the account number: ").strip()
        query = "SELECT accNo FROM accounts WHERE accNo LIKE %s"
        accounts = execute_query(query, f'%{last_4_digits}', fetch_all=True)
        if not accounts:
            print("No account found with the provided last 4 digits.")
            return

        accNo_to_delete = accounts[0][0]
        print(f"Deleting account with number: {accNo_to_delete}")  # Debug print
        query = "DELETE FROM accounts WHERE accNo = %s"
        if execute_query(query, accNo_to_delete):
            print("Account deleted successfully!")
        else:
            print("Failed to delete the account.")
    except ValueError as ve:
        print("Invalid input.")


# Function to display all accounts
def display_all_accounts():
    query = "SELECT * FROM accounts"
    accounts = execute_query(query, fetch_all=True)
    if accounts:
        for account in accounts:
            print(f"Account Number: {account[0]}, Name: {account[1]}, Type: {account[2]}, Balance: {account[3]}")
    else:
        print("Failed to fetch data.")


# Main function with menu
def main():
    while True:
        print("\tMAIN MENU")
        print("\t1. NEW ACCOUNT")
        print("\t2. DEPOSIT AMOUNT")
        print("\t3. WITHDRAW AMOUNT")
        print("\t4. BALANCE ENQUIRY")
        print("\t5. ALL ACCOUNT HOLDER LIST")
        print("\t6. CLOSE AN ACCOUNT")
        print("\t7. EXIT")
        ch = input("Select Your Option (1-7): ").strip()

        if ch == '1':
            create_account()
        elif ch == '2':
            last_4_digits = input("Enter the last 4 digits of the account number: ").strip()
            amount = float(input("Enter the amount to deposit: ").strip())
            deposit_or_withdraw(last_4_digits, amount, "deposit")
        elif ch == '3':
            last_4_digits = input("Enter the last 4 digits of the account number: ").strip()
            amount = float(input("Enter the amount to withdraw: ").strip())
            deposit_or_withdraw(last_4_digits, amount, "withdraw")
        elif ch == '4':
            last_4_digits = input("Enter the last 4 digits of the account number: ").strip()
            display_account(last_4_digits)
        elif ch == '5':
            display_all_accounts()
        elif ch == '6':
            delete_account()
        elif ch == '7':
            print("Thanks for using the bank management system.")
            break
        else:
            print("Invalid choice. Please try again.")


if __name__ == "__main__":
    main()