#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "Welcome to the salon shop!\n"

MAIN_MENU() {
  # allow the ability to add a commment when directed back to the main menu
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # listing out all of the services
  echo -e "\nPlease select one of the following services:"
  SERVICES=$($PSQL "SELECT service_id, name FROM services;")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    if [[ $SERVICE_ID =~ ^[0-9]+$ ]]
    then
      echo "$SERVICE_ID)" "$NAME"
    fi
  done
  echo "0) Main Menu"
}

SELECT_SERVICE() {
  read SERVICE_ID_SELECTED

  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED';")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED';")

  # no valid option selected
  if [[ -z $SERVICE_ID ]] && [[ ! $SERVICE_ID_SELECTED = 0 ]]
  then
    MAIN_MENU "Not a valid option"

  # if selected the menu option
  elif [[ $SERVICE_ID_SELECTED = 0 ]]
  then
    MAIN_MENU "You have returned to the main menu."

  # if selected one of the service options
  else
    echo -e "\nPlease enter your phone number in ###-#### format."
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

    # if new customer
    if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nPhone number does not exist. Please enter your name to register."
      read CUSTOMER_NAME
      # adding phone and customer name and getting customer_id
      ADD_CUSTOMER=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")


      #adding service time
      echo -e "\nPlease input a service time."
      read SERVICE_TIME
      ADD_SERVICE_TIME=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
      SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ //')
      echo "I have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."


    else
      # if existing customer
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
      # adding service time
      echo -e "\nPlease input a service time."
      read SERVICE_TIME
      ADD_SERVICE_TIME=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
      SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ //')
      echo "I have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."

    fi





  fi
}

MAIN_MENU
SELECT_SERVICE
