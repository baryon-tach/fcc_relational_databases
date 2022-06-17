#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# RENAME COLUMNS
  RENAME_WEIGHT=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;")
  RENAME_CELSIUS=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;")
  RENAME_CELSIUS=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;")

# NOT NULL
  CELSIUS_NNULL=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;")
  CELSIUS_NNULL=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;")

# UNIQUE CONSTRAINT AND NOT NULL
  COL_UNIQUE=$($PSQL "ALTER TABLE elements ADD CONSTRAINT symbol UNIQUE(symbol), ALTER COLUMN symbol SET NOT NULL;")
  COL_UNIQUE=$($PSQL "ALTER TABLE elements ADD CONSTRAINT name UNIQUE(name), ALTER COLUMN name SET NOT NULL;")

# FOREIGN KEY
  COL_FKEY=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);")
  CREATE_TTABLE=$($PSQL "CREATE TABLE types(type_id INT PRIMARY KEY, type VARCHAR(50) NOT NULL);")

# ADD THREE ROWS
  ADD_ROWS=$($PSQL "INSERT INTO types (type_id, type) VALUES (1, 'metal'), (2, 'nonmetal'), (3, 'metalloid');")

# ADD TYPE_ID TO PROPERTIES AND SET NULL
  ADD_ID=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT REFERENCES types(type_id);")
  SET_TYPE_ID=$($PSQL "UPDATE properties SET type_id=types.type_id FROM types WHERE properties.type=types.type;")
  ADD_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;")

# DELETE ATOMIC_NUMBER 1000
  DELETE_ATOM=$($PSQL "DELETE FROM properties WHERE atomic_number=1000;")
  DELETE_ATOM=$($PSQL "DELETE FROM elements WHERE atomic_number=1000;")

# # CAPITALIZE FIRST LETTER OF SYMBOLS
# # DEFINE CAPTIALIZE FUNCTION
CAPITALIZE(){
  WORD=$(echo $1 | sed 's/ //g')
  ATOMIC_NUMBER=$2
    # ignore syntax index the string
      # EDITED=${WORD:0:1}
  EDITED=${WORD^}
    # test to see if echoing right
      # echo $EDITED $ATOMIC_NUMBER
  CAP_SYMBOL=$($PSQL "UPDATE elements SET symbol='$EDITED' WHERE atomic_number=$ATOMIC_NUMBER;")
}
# OBTAIN VALUES TO CAP
TO_EDIT=$($PSQL "SELECT symbol, atomic_number FROM elements;")
# must put in echo "___" in order for the while loop to go through each otherwise they will be jumbled up together
echo "$TO_EDIT" | while read SYMBOL BAR ATOMIC_NUMBER
do
  CAPITALIZE $SYMBOL $ATOMIC_NUMBER
done

# CHANGE DATATYPE TO DECIMAL SO THAT THE BELOW WILL REMOVE THE TRAILING 0s
CHANGE_DEC=$($PSQL "ALTER TABLE properties ALTER atomic_mass TYPE DECIMAL;")

# REMOVE ALL TRAILING ZEROS AFTER DECIMALS FROM EACH ROW OF ATOMIC_MASS
REMOVE_ZEROS(){
  ATOMIC_MASS=$1
  ATOMIC_NUMBER=$2
  EDIT_MASS=$(echo $1 | awk '{ if ($0 ~ /\./) {sub("0*$","",$0)} print }')
  # echo $EDIT_MASS
  INSERT_EDITS=$($PSQL "UPDATE properties SET atomic_mass=$EDIT_MASS WHERE atomic_number=$ATOMIC_NUMBER;")
  echo $INSERT_EDITS
}
# GET DATA
GET_NUM=$($PSQL "SELECT atomic_mass, atomic_number FROM properties;")
echo "$GET_NUM" | while read ATOMIC_MASS BAR ATOMIC_NUMBER
do
  REMOVE_ZEROS $ATOMIC_MASS $ATOMIC_NUMBER
done

# ADD VALUES
INSERT_ELEMENTS=$($PSQL "INSERT INTO elements (atomic_number, symbol, name) VALUES (9, 'F' ,'Fluorine'),
 (10, 'Ne', 'Neon');")
INSERT_PROPERTIES=$($PSQL "INSERT INTO properties (atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES
(9, 'nonmetal', 18.998, -220, -188.1, 2),
(10, 'nonmetal', 20.18, -248.6, -246.1, 2);")

# DROP TYPE COLUMN IN PROPERTIES
DROP_TYPE=$($PSQL "ALTER TABLE properties DROP COLUMN type;")
