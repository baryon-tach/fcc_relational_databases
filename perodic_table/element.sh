#!/bin/bash

# requests
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # see if atomic number is used
  if [[ $1 =~ ^[0-9]*$ ]]
  then
    AN=$($PSQL "SELECT atomic_number, name, symbol, CHEM.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM (SELECT * FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number='$1') AS CHEM;")
    echo $AN | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      #if not valid entry
      if [[ -z $NAME ]]
      then
        echo "I could not find that element in the database."
      else
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      fi
    done
  else
    # length of the first argument
    if [[ ${#1} -le 2 ]]
    then
      SB=$($PSQL "SELECT atomic_number, name, symbol, CHEM.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM (SELECT * FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$1') AS CHEM;")
      echo $SB | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        #if not valid entry
        if [[ -z $NAME ]]
        then
          echo "I could not find that element in the database."
        else
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
      done
    # get name of element
    else
      NM=$($PSQL "SELECT atomic_number, name, symbol, CHEM.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM (SELECT * FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE name='$1') AS CHEM;")
      echo $NM | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        #if not valid entry
        if [[ -z $NAME ]]
        then
          echo "I could not find that element in the database."
        else
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
      done
    fi








  fi
fi
