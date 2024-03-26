#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
INPUT="$1"
if [[ $1 ]]
then
if [[ $INPUT =~ ^[0-9]+$ ]]
then
  A_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT")
else
  A_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT'")
fi
if [[ ! -n "$A_NUMBER" ]]
then
  echo I could not find that element in the database.
else
  S=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$A_NUMBER")
  N=$($PSQL "SELECT name FROM elements WHERE atomic_number=$A_NUMBER")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$A_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  AM=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$A_NUMBER")
  MPC=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$A_NUMBER")
  BPC=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$A_NUMBER")
  echo "The element with atomic number $A_NUMBER is $N ($S). It's a $TYPE, with a mass of $AM amu. $N has a melting point of $MPC celsius and a boiling point of $BPC celsius."
fi
else
  echo Please provide an element as an argument.
fi
