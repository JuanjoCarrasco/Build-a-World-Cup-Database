#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $WINNER != "winner" ]]
  then
    #get team_id of winner
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    #if not found
    if [[ -z $WINNER_ID ]]
    then
      #insert team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
      #get new team_id 
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi

    #get team_id of opponent   
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert team
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      #get new team_id 
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi

    #insert data
    INSERT_DATA_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, winner_goals, opponent_goals, opponent_id) 
                       VALUES($YEAR, '$ROUND', $WINNER_ID, $WINNER_GOALS, $OPPONENT_GOALS, $OPPONENT_ID)")
    if [[ $INSERT_DATA_RESULT == "INSERT 0 1" ]]      
      then
        echo Inserted into games, $YEAR $ROUND $WINNER_ID $WINNER_GOALS $OPPONENT_GOALS $OPPONENT_ID
    fi


  fi  
done