#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi 

echo -e "\nTotal Teams : $($PSQL "select count(*) from teams")"
echo -e "\nTotal Games : $($PSQL "select count(*) from games")" 

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
do
  if [[ $WINNER != "winner" ]]
  then
    #get team id 
    TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")

    #if not found 
    if [[ -z $TEAM_ID ]]  
    then  
      #insert winner
      $($PSQL "insert into teams(name) values('$WINNER')")
    fi
 
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    #get team id 
    TEAM_ID2=$($PSQL "select team_id from teams where name='$OPPONENT'")
  
    #if not found
    if [[ -z $TEAM_ID2 ]] 
    then 
      #insert winner   
      $($PSQL "insert into teams(name) values('$OPPONENT')")
    fi

  fi

  #games table work
  if [[ $YEAR != "year" && $ROUND != "round" && $WG != "winner_goals" && $OG != "opponent_goals" ]]
  then
    #get the winner team id 
    WID=$($PSQL "select team_id from teams where name='$WINNER'") 
    #get the opponent team id
    OID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    #insert game 
    $($PSQL "insert into games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) values('$YEAR', '$ROUND', '$WG', '$OG', '$WID', '$OID')")
  fi
  
done

echo -e "\nTotal Teams : $($PSQL "select count(*) from teams")"  
echo -e "\nTotal Games : $($PSQL "select count(*) from games")"