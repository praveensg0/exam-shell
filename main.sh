#!/bin/bash

sign_up() {
	header
	echo -e "\e[92m<<<<<\e[0m Create an Account \e[92m>>>>>\e[0m"
	users=($(cat usernames.csv))
	echo "Enter Username:"
	read username
	for user in $(seq 0 $((${#users[@]} - 1))); do
		userid=${users[$user]}
		if [ $userid = $username ]; then
			echo -e "\e[31mUsername already exists! Please choose a different username.\e[0m"
			sign_up
		fi
	done
	pw=1
	while [ $pw -ne 0 ]; do
		echo "Enter Password: "
		read -s password
		if [ ${#password} -lt 6 ]; then
			echo -e "\e[31mPlease use at least 6 characters for the password.\e[0m"
		else
			pw=0
		fi
	done
	pass=1
	attempts=4
	while [ $pass -ne 0 -a $attempts -ne 0 ]; do
		echo "Confirm Password: "
		read -s conf_password
		if [ $conf_password = $password ]; then
			pass=0
			echo -e "\e[32mCongratulations! Your account has been created successfully!\e[0m"

			echo $username >>usernames.csv
			echo $conf_password >>passwords.csv
			welcome
		else
			attempts=$(($attempts - 1))
			echo -e "\e[31mPasswords do not match! Remaining Attempts: $attempts\e[0m"

			if [ $attempts -eq 0 ]; then
				echo -e "\e[31mSorry! You have exceeded the maximum limit.\e[0m"
				echo "Please sign up again!"
				sign_up
			fi
		fi
	done
}

sign_in() {
	header
	echo -e "\e[32m\e[0m Log In \e[32m\e[0m"
	users=($(cat usernames.csv))
	found=0
	attempts=4
	while [ $found -ne 1 -a $attempts -ne 0 ]; do
		echo -e "\e[34mEnter Username:\e[0m "
		read login_user
		for user in $(seq 0 $((${#users[@]} - 1))); do
			if [ ${users[$user]} = $login_user ]; then
				found=1
				position=$user
			fi
		done
		if [ $found -eq 1 ]; then
			echo -e "\e[92m:) Welcome back!\e[0m"
		else
			echo -e "\e[31mUsername not found.\e[0m"
			attempts=$(($attempts - 1))
			if [ $attempts -gt 0 ]; then
				echo "Please try again"
				echo "You have $attempts attempts remaining"
			else
				echo -e "\e[31mSorry! You have exceeded the maximum limit.\e[0m"
				echo "Please sign up again"
				welcome
			fi
		fi
	done

	passwords=($(cat passwords.csv))
	attempts=4
	found=0
	while [ $found -ne 1 -a $attempts -ne 0 ]; do
		echo -e "\e[34mEnter Password:\e[0m "
		read -s login_pass
		echo
		if [ ${passwords[$position]} = $login_pass ]; then
			echo -e "\e[92mLogin Successful! You can start your exam.\e[0m"
			start_test
			found=1
		else
			echo -e "\e[31mWrong Password! Please try again.\e[0m"
			attempts=$(($attempts - 1))
			if [ $attempts -gt 0 ]; then
				echo "You have $attempts attempts remaining"
			else
				echo -e "\e[31mSorry! No more attempts. Please try later\e[0m"
				welcome
			fi
		fi
	done
}

start_test() {
	header
	echo -e "1) \e[32mTake the Test\e[0m"
	echo -e "2) \e[31mExit\e[0m"
	echo
	read -p "Enter your choice: " choice
	line=$(cat exam_questions.txt | wc -l)

	case $choice in
	1)
		for i in $(seq 5 5 $line); do
			header
			echo
			head -$i exam_questions.txt | tail -5
			echo
			for j in $(seq 10 -1 1); do
				echo -e "\r\e[31mEnter the correct answer\e[0m \e[32m$j\e[0m : \c"
				read -t 1 ans
				if [ ${#ans} -ne 0 ]; then
					break
				fi
			done
			if [ ${#ans} -eq 1 ]; then
				echo "$ans" >>user_answers.txt
			else
				echo "No_Answer" >>user_answers.txt
			fi
			echo
		done
		;;

	2)
		exit
		;;

	*)
		echo -e "\e[31mPlease choose correct option.\e[0m"
		start_test
		;;
	esac
	results
}

results() {
	header
	correct_answers=($(cat correct_answers.txt | tr -s ' ' | cut -d ':' -f1))
	correct_answers_text=($(cat correct_answers.txt | tr -s ' ' | cut -d ':' -f2))
	user_answers=($(tail -5 user_answers.txt))
	score=0

	for i in $(seq 0 $((${#correct_answers[@]} - 1))); do
		if [ ${correct_answers[i]} = ${user_answers[i]} ]; then
			echo -e "Q$(($i + 1))) Your answer is : \e[32m${correct_answers[i]} (Correct)\e[0m"
			echo -e "\e[32mQ$(($i + 1)))\e[0m \e[34mCorrect answer is :\e[0m \e[32m${correct_answers[i]}. ${correct_answers_text[i]}\e[0m"
			echo
			score=$(($score + 1))
		else
			echo -e "Q$(($i + 1))) Your answer is : \e[31m${user_answers[i]} (Incorrect)\e[0m"
			echo -e "\e[32mQ$(($i + 1)))\e[0m \e[34mCorrect answer is :\e[0m \e[32m${correct_answers[i]}. ${correct_answers_text[i]}\e[0m"
			echo
		fi
	done
	echo -e "\e[32mYour Total Score\e[0m: $score Marks"
	echo
	exit

}

header() {
	sleep 2s
	clear
	echo ____________________________________________________
	echo
	echo -e "\e[32m                  \e[0m \e[1;4mOnline Exam\e[0m \e[32m                  \e[0m"
	echo -e "\e[31mTotal Marks\e[0m : 5                    \e[31mTime\e[0m : 50 Seconds"
	echo ____________________________________________________

}

welcome() {
	header
	echo -e "1.\e[92mCreate an Account\e[0m"
	echo -e "2.\e[92mLog In\e[0m"
	echo -e "3.\e[92mExit\e[0m"
	echo

	read -p "Please choose an option: " choice

	case $choice in
	1)
		echo -e "\e[92mGreat! Let's create your account.\e[0m"
		sign_up
		;;

	2)
		echo -e "\e[92mWelcome back! Please log in.\e[0m"
		sign_in
		;;

	3)
		exit
		;;

	*)
		echo -e "\e[91mPlease choose a correct option.\e[0m"
		welcome
		;;

	esac

}

welcome
