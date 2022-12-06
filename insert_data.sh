#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE teams RESTART IDENTITY CASCADE")"
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do

  #if not 'winner' insert team on table teams
  if [[ $winner != winner ]]
    then
    CHECK=$($PSQL "SELECT * FROM teams WHERE name='$winner'")
    if [[ -z "$CHECK" ]]
      then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$winner')")"
    fi
    CHECK=$($PSQL "SELECT * FROM teams WHERE name='$opponent'")
    if [[ -z "$CHECK" ]]
      then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")"
    fi
  fi

  #insert every game intos games table
  WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
  if [[ $WIN_ID != winner && $OPP_ID != opponent ]]
    then
    echo "$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,opponent_goals,winner_goals) VALUES($year, '$round', $WIN_ID, $OPP_ID, $opponent_goals, $winner_goals)")"
  fi
done
