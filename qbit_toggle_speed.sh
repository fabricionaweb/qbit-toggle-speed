#!/bin/bash -e

# -------------------------
# qbittorrent credentials
USER="admin"
PASSWORD="adminadmin"

# qbittorrent web api
ENDPOINT="http://tower.lan:9090/api/v2"

# path to store the cookies (no need to change)
JAR="qbit-cookies.txt"
# -------------------------

# $1 is the script argument
ACTION="$1"
if [[ "$ACTION" != "enable" && "$ACTION" != "disable" ]]; then
  echo "Invalid argument, expected 'enable' or 'disable'"
  exit 1
fi

# try to login
AUTH=$(curl -sS $ENDPOINT/auth/login --cookie-jar $JAR -d "username=$USER&password=$PASSWORD")

if [[ "$AUTH" != "Ok." ]]; then
  echo $AUTH
  echo "Not possible to authenticate"
  exit 1
fi

# gets the current state
#   1 is enabled
#   0 is disabled
STATE=$(curl -sS $ENDPOINT/transfer/speedLimitsMode --cookie $JAR)

# you want turn on but it is already on
if [[ "$ACTION" == "enable" && "$STATE" == "1" ]]; then
  echo "Already on"
  exit 0
fi

# you want turn off but it is already off
if [[ "$ACTION" == "disable" && "$STATE" == "0" ]]; then
  echo "Already off"
  exit 0
fi

# toggle
curl -sSX POST $ENDPOINT/transfer/toggleSpeedLimitsMode --cookie $JAR -H 'Content-Length: 0'

# non error
if [[ "$ACTION" == "enable" ]]; then
  echo "Enabled"
else
  echo "Disabled"
fi
