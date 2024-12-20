#! /usr/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo -e "${GREEN}running tcpdump in the background${RESET}"
nohup tcpdump -i eth1 tcp -w capture.pcap &

sleep 3
echo -e "\n${GREEN}downloading http file from Server${RESET}"
wget -O - http://10.0.0.20:8000

sleep 1
echo -e "\n${GREEN}stoping tcpdump to read capture.pcap${RESET}"
tcpdump_pid=$(pgrep -f "tcpdump -i eth1 tcp -w capture.pcap")
kill $tcpdump_pid

sleep 1
echo -e "\n${GREEN}Showing captured packets${RESET}"
tcpdump -r ./capture.pcap

