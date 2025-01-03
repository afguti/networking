#! /usr/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Ask the user for input
echo "This Lab will setup BGP in R1 and R2 and start tcpdump in R2"
echo "The output capture.pcap will be located in /tmp directory\n"
read -p "Do you want to proceed? (yes/no): " answer

# Convert the answer to lowercase to make it case-insensitive
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

# Check if the answer is 'yes' or 'no'
if [[ "$answer" == "yes" || "$answer" == "ye" || "$answer" == "y" ]]; then
  echo -e "${BLUE}Proceeding...${RESET}\n"
  echo -e "Setting up R1...\n"
  sudo docker exec -it clab-simple-bgp-R1 sh -c ". tmp/r1.sh && sleep 2 && solution -y"
  echo -e "\nRunning command in R2 side..."
  sleep 3
  sudo docker exec -it clab-simple-bgp-R2 sh -c ". tmp/r2.sh && sleep 2 && solution -y"
  echo -e "\n${BLUE}END OF THE LAB${RESET}"
elif [[ "$answer" == "no" || "$answer" == "n" ]]; then
  echo -e "\nOperation canceled."
else
  echo -e "\n${RED}Invalid input. Please answer with 'yes' or 'no'.${RESET}"
fi