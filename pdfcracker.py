import pikepdf
from tqdm import tqdm

# Load password list with Latin-1 encoding
with open("rockyou.txt", encoding="latin-1") as file:
    passwords = [line.strip() for line in file]

# Iterate over passwords
for password in tqdm(passwords, "Decrypting PDF"):
    try:
        # Open PDF file
        with pikepdf.open("AYUSH.pdf", password=password, allow_overwriting_input=True) as pdf:
            # Password decrypted successfully, break out of the loop
            print("[+] Password found:", password)
            break
    except pikepdf._core.PasswordError as e:
        # Wrong password, just continue in the loop
        continue
