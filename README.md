# Online Exam System

This is a simple Bash script for an online exam system. Users can create an account, log in, take the exam, and view their results.

## Demo

[shelldemo.webm](https://github.com/praveensg0/exam-shell/assets/144553645/368d9648-8dcb-444e-857e-d470026feae8)


## Features

- **User Authentication:** Users can create an account with a unique username and password.
- **Exam Taking:** Users can take the exam consisting of multiple-choice questions.
- **Results:** After completing the exam, users can view their results.

## Files

1. **Script:** `main.sh` - The main Bash script containing the functionality for account creation, login, exam taking, and result display.
2. **Usernames:** `usernames.csv` - A CSV file storing usernames.
3. **Passwords:** `password.csv` - A CSV file storing passwords.
4. **Exam Questions:** `questions.txt` - A text file containing the exam questions.
5. **Correct Answers:** `answers.txt` - A text file containing the correct answers to the exam questions.
6. **User Answers:** `user_answers.txt` - A text file containing the user's answers to the exam questions.

## Usage

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/praveensg0/exam-shell.git
    ```

2. **Navigate to the Directory:**

    ```bash
    cd exam-shell
    ```

3. **Run the Script:**

    ```bash
    ./main.sh
    ```

4. **Follow the On-Screen Instructions:**

    - Choose "Create an Account" to register or "Log In" if you already have an account.
    - Take the exam by selecting the appropriate option.
    - View your results at the end.

## Note

- Ensure that all files are in the same directory as the Bash script for proper functionality.
- The passwords are stored in plain text format, which is not recommended for real-world applications.
