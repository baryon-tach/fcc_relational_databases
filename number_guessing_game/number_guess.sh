#!/bin/bash

# query
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


# def function the game
GUESS_NUM(){
  # random number
  RANDOM_NUMBER=$(( 1 + RANDOM % 1000 ))

  # count the times guessed and give hints
  count=0
  echo -e "\nGuess the secret number between 1 and 1000:"
  read GUESS
  (( count=count+1 ))
  until [ $GUESS == $RANDOM_NUMBER ]
  do
    if [[ $GUESS =~ ^[0-9]*$ ]]
    then
        # if guess is lower than random number
      if [[ $GUESS -lt $RANDOM_NUMBER ]]
      then
        echo -e "\nIt's higher than that, guess again:"
        read GUESS
        (( count=count+1 ))

      elif [[ $GUESS -gt $RANDOM_NUMBER ]]
      then
        echo -e "\nIt's lower than that, guess again:"
        read GUESS
        (( count=count+1 ))
      fi
    else
      echo -e "\nThat is not an integer, guess again:"
      read GUESS

    fi
  done
  echo -e "\nYou guessed it in $count tries. The secret number was $RANDOM_NUMBER. Nice job!"

  # adding to games
  USER_ID=$1
  INSERT_GAMES=$($PSQL "INSERT INTO games(user_id, total_tries, random_number) VALUES($USER_ID, $count, $RANDOM_NUMBER);")
  TOTAL_GAMES=$($PSQL "SELECT count(user_id) FROM games WHERE user_id=$USER_ID;")
  BEST_GAME=$($PSQL "SELECT MIN(total_tries) FROM games WHERE user_id=$USER_ID;")

  # updating user
  UPDATE_USER=$($PSQL "UPDATE users SET games_played=$TOTAL_GAMES, best_game=$BEST_GAME WHERE user_id=$USER_ID;")

}


# input
echo -e "\nEnter your username:"
read USERNAME

# get user_name
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

# new user
if [[ -z $USER_ID ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  # add new user
  ADD_USER=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME');")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")
  GUESS_NUM $USER_ID
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME';")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME';")
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  GUESS_NUM $USER_ID

fi
