#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #exclude header
  if [[ $YEAR != "year" ]]
  then
    #do we already have this winning team?
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")
    if [[ -z $TEAM_ID_WINNER ]]
    then
    #we didn't find that team so we need to insert
      $($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    fi
    #and what about the losing team?
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT' ")
    if [[ -z $TEAM_ID_OPPONENT ]]
    then
    #we didn't find that team so we need to insert
      $($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    fi
    
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #exclude header
  if [[ $YEAR != "year" ]]
  then
    #get team ids first for single insert
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT' ")
    #now insert everything
    $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done