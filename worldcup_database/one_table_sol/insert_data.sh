#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Make sure to create the database worldcup and one table - games
# For games include the columns game_id SERIAL PRIMARY KEY, year INT, round VARCHAR(30), winner VARCHAR(30), opponent VARCHAR(30), winner_goals INT, opponent_goals INT


# Create a query variable
PSQL="psql -X --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Remove data
$PSQL "TRUNCATE games"


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  #prevent the first line from being added into the database
  if [[ $YEAR != year ]]
  then
    echo "$($PSQL "INSERT INTO games(year, round, winner, opponent, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', '$WINNER', '$OPPONENT', '$WINNER_GOALS', '$OPPONENT_GOALS');")"
  fi
done

