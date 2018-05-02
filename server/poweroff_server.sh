#!/bin/bash
#
# Poweroff: SERVER (simplified version)
#
#
WWWDIR="/var/web-data/infra/poweroff"
CONFDIR="/var/web-data/infra/poweroff/data"
SHEET='https://docs.google.com/spreadsheets/d/1tFzLX1xJJXaxWl9zP5LrL0SWU8iOpz0kH9hT_bKHnw8/pub?gid=1877862683&single=true&output=csv'


START_TIME=08:00
NOW=$(date +%s)
BEGIN=$(date --date="$START_TIME" +%s)
TODAY_NUMBR=$(date +%j)
LOG_PREVIOWS=$CONFDIR/$((TODAY_NUMBR -1)).log
LOG_HLT_TODAY=$CONFDIR/$TODAY_NUMBR.log


LOG_HLT=halt.log
CSV_TMP=$(mktemp)
CSV_FILE=$CONFDIR/data.csv

# Getting spreadsheet data
curl -L $SHEET -o $CSV_TMP 2> /dev/null

# if file exists and has a size greater than zero 
if [[ -s $CSV_TMP ]]; then
   cp $CSV_TMP $CSV_FILE
else   
   echo "FILE IS EMPTY"
   exit
fi

# 
SHUTDOWN=()

while IFS='' read -r line || [[ -n "$line" ]]; do
   SHUTDOWN+=("$line")
#   echo $line
done < "$CSV_FILE"

LAB_POWEROFF=$(echo ${SHUTDOWN[1]} |tr '\n' ' ')
TERM_POWEROFF=$(echo ${SHUTDOWN[0]} |tr '\n' ' ')

setSignal () {

   if [ $1 == "ordinary" ]; then
	echo $2 > $WWWDIR/ordinary/index.htm
   else
   	echo $2 > $WWWDIR/lab/index.htm
   fi


  # LOG
  if [ "$NOW" -ge "$BEGIN" ]; then
    if [[ -s $LOG_HLT_TODAY ]]; then
       CODELINES=`wc -l $LOG_HLT_TODAY |cut -d' ' -f1`

       if [ "$CODELINES" -lt 2 ]; then
         LOG_TYP=`grep -o $1 $LOG_HLT_TODAY`
	 if [ "$1" != "$LOG_TYP" ]; then
      	   echo "$(date) - Halt $1" >> $LOG_HLT_TODAY
	 fi
       fi
     else
       cat $LOG_PREVIOWS >> $LOG_HLT
       rm $LOG_PREVIOWS
       echo "$(date) - Halt $1" > $LOG_HLT_TODAY
     fi
  fi
}

verify () {

  if [[ "$2" == *"off"* ]]; then
    echo "HALT* $1"
    setSignal "$1" "off" 
  elif [[ "$2" == *"on"* ]]; then
    echo "LIVE* $1"
    setSignal "$1" "on"
  else
    NOW=$(date +%s)
    HALT=$(date --date="$2" +%s)
     
    if [ "$NOW" -ge "$HALT" ]; then
      echo "HALT $1 - $2"
      setSignal "$1" "off"
    else
      echo "LIVE $1 - $2"
      setSignal "$1" "on"
    fi 

  fi

}

verify "ordinary" $TERM_POWEROFF
verify "lab" $LAB_POWEROFF

