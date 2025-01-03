#! /usr/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo "setting up a HTTP server with: nohup python3 -m http.server &"
nohup python3 -m http.server &

sleep 2

echo -e "\nrunning ps aux and netstat for confirmation"
ps aux
netstat -tlp