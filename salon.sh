#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\nWelcome to my Salon, How may I help you...?"



MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi



#Show available services
SERVICE_AVAILABLE=$($PSQL "SELECT * FROM services")

#checking services availability
if [[ -z $SERVICE_AVAILABLE ]]
then
  echo -e "\nI'm sorry, don't have any available service"
else
  echo -e "$SERVICE_AVAILABLE" | while read SERVICE_ID BAR NAME
  do
    echo  "$SERVICE_ID) $NAME"
  done
fi
#enter service id
echo -e "\nPlease enter your service option"
read SERVICE_ID_SELECTED
if [[  $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
then

  #are you a customer?

  #enter phone number
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE
  #phone number entered exist? you should get the customers name and enter it, and the phone number, into the customers table
  if [[ -z $CUSTOMER_PHONE ]]
    then
    echo "phone string is empty"
    else
    VALID_PHONE=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $VALID_PHONE ]]
    then
      #create a new customer
      #enter your name
      echo -e "\nPlease enter your name"
      read CUSTOMER_NAME
      #enter the time
      echo -e "\nWhat time the service should be for?"
      read SERVICE_TIME
      INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      INSERT_CUSTOMER_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo "Welcome $CUSTOMER_NAME"
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      UNIFIED_DATA=$($PSQL "SELECT * FROM customers INNER JOIN appointments USING(customer_id) WHERE customer_id=$CUSTOMER_ID")
      echo "$UNIFIED_DATA" | while read CID BAR PHN BAR NAM BAR APP BAR SER BAR TIM
      do
          echo " I have put you down for a $SERVICE_NAME at $TIM, $NAM."
      done

    else
    echo "Welcome back "
    fi
  fi
  

else
  MAIN_MENU "Please select a valid option"
fi
}
MAIN_MENU