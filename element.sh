#!/bin/bash
# command to be able to query the database
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi
#set input variable to first argument
INPUT=$1

# Determine if input is atomic number (number) or symbol/name (string)
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  # Input is atomic number
  ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
                        FROM elements
                        JOIN properties USING(atomic_number)
                        JOIN types USING(type_id)
                        WHERE elements.atomic_number = $INPUT;")
else
  # Input is symbol or name
  ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
                        FROM elements
                        JOIN properties USING(atomic_number)
                        JOIN types USING(type_id)
                        WHERE elements.symbol = '$INPUT' OR elements.name = '$INPUT';")
fi

if [[ -z $ELEMENT_INFO ]]; then
  echo "I could not find that element in the database."
else
  # Split the info into variables
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT_INFO"

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi


# SIGNED: EBUKA
