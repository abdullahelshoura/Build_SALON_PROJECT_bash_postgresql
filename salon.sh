#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo  "Welcome to My Salon, how can I help you?"
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED
  if [ $SERVICE_ID_SELECTED -ge 1 -a $SERVICE_ID_SELECTED -le 5 ]
  then
    SERVICE_MENU
  else
    MAIN_MENU "I could not find that service. What would you like today?vv"
  fi
}


SERVICE_MENU() {
  #get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  
  #check if customer not exist
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
 
  # if customer not exist
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?\n"
    read CUSTOMER_NAME
    
    # insert customer
    INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    
    #get customer inserted id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
  #get customer name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
  
  #get service time to insert
  echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g'),$CUSTOMER_NAME?\n"
  read SERVICE_TIME
  
  #insert appointment
  INSERT_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(time,service_id,customer_id) VALUES('$SERVICE_TIME',$SERVICE_ID_SELECTED,$CUSTOMER_ID)")
  echo -e "I have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME,$CUSTOMER_NAME."

}
MAIN_MENU


