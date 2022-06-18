#!/bin/bash

# QUERY
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# CREATE USERS TABLE
CREATE_USER_TABLE=$($PSQL "CREATE TABLE users(user_id SERIAL PRIMARY KEY, username VARCHAR(30) NOT NULL UNIQUE, , games_played INT, best_game INT);")

# CREATE GAMES TABLE
CREATE_GAMES_TABLE=$($PSQL "CREATE TABLE games(game_id SERIAL PRIMARY KEY, user_id INT NOT NULL REFERENCES users(user_id), total_tries INT, random_number INT NOT NULL);")
