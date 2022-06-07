#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Make sure to create the database worldcup and one table - games and teams
# For games include the columns game_id SERIAL PRIMARY KEY, year INT, round VARCHAR(30), winner_goals INT, opponent_goals INT, winner_id (fkey team_id), opponent_id (fkey team_id)
# For teams include the columns team_id SERIAL PRIMARY KEY, name VARCHAR(30) UNIQUE


# Create a query variable
PSQL="psql -X --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Remove data and reset seqence
$PSQL "TRUNCATE games, teams RESTART IDENTITY CASCADE"



cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  #prevent the first line from being added into the database
  if [[ $YEAR != year ]]
  then
    # for winner column
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER');")
      # if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      # then
      #   echo Inserted into name, $WINNER
      # fi

    fi
    #for opponent column
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT');")
      # if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      # then
      #   echo Inserted into name, $OPPONENT
      # fi
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    INSERT_GAMES=$($PSQL "INSERT INTO games (winner_id, opponent_id, year, round, winner_goals, opponent_goals) VALUES ($WINNER_ID, $OPPONENT_ID, $YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS);")
    # if [[ $INSERT_GAMES == "INSERT 0 1" ]]
    # then
    #   echo Inserted into games, $WINNER_ID : $OPPONENT_ID : $YEAR : $ROUND : $WINNER_GOALS : $OPPONENT_GOALS
    # fi
  fi
done
