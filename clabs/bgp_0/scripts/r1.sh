#! /usr/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo -e "${GREEN}making sure bgpd is enabled in /etc/frr/deamons${RESET}"
if grep -q "^bgpd=yes" /etc/frr/daemons; then
    echo -e "${BLUE}bgpd already enabled${RESET}"
else
    sed -i 's/^bgpd=no/bgpd=yes/' /etc/frr/daemons
    echo -e "${BLUE}bgpd enabled${RESET}"
fi

$(find / -name zebra) -d
$(find / -name bgpd) -d

alias enable='vtysh'

function solution {
    if [[ "$1" == "-y" ]]; then
      answer="yes"
    else
      read -p "Do you want to proceed applying BGP config? (yes/no): " answer
    fi

    # Convert the answer to lowercase to make it case-insensitive
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

    # Check if the answer is 'yes', 'ye', 'y', 'no', or 'n'
    if [[ "$answer" == "yes" || "$answer" == "ye" || "$answer" == "y" ]]; then
      echo -e "${BLUE}Proceeding...${RESET}\n"
      echo -e "Setting up the frr.conf...\n"
      cp /etc/frr/frr-r1.conf /etc/frr/frr.conf
      echo -e "\nRestarting FRR..."
      sleep 1
      $(find / -name frrinit.sh) restart
      echo -e "\n${BLUE}BGP configuration applied${RESET}"
    elif [[ "$answer" == "no" || "$answer" == "n" ]]; then
      echo -e "\nOperation canceled."
    else
      echo -e "\n${RED}Invalid input. Please answer with 'yes' or 'no'.${RESET}"
    fi
}
