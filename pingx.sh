#!/bin/bash

IP="1.1.1.1"

COMMAND="sudo systemctl restart easymesh.service"

PING_COUNT=4

LOG_FILE="/var/log/ping_check.log"

echo "Ping check started at $(date)" >> $LOG_FILE

while true; do

  PING_RESULT=$(ping -c $PING_COUNT $IP)
  if [ $? -eq 0 ]; then
    echo "$(date): Ping successful to $IP" >> $LOG_FILE
    echo "$PING_RESULT" >> $LOG_FILE
  else
    echo "$(date): Ping failed to $IP" >> $LOG_FILE

    COMMAND_OUTPUT=$($COMMAND 2>&1)
    echo "$(date): Command executed: $COMMAND" >> $LOG_FILE
    echo "$(date): Command output: $COMMAND_OUTPUT" >> $LOG_FILE
  fi

  sleep 60
done
