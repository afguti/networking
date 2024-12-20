#! /usr/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Ask the user for input
echo "This Lab will start a http session with R1 and capture the packets of the 3 way handshake negotiation."
echo "The output capture.cap will be located in /tmp directory\n"
read -p "Do you want to proceed? (yes/no): " answer

# Convert the answer to lowercase to make it case-insensitive
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

# Check if the answer is 'yes' or 'no'
if [[ "$answer" == "yes" ]]; then
  echo -e "${BLUE}Proceeding...${RESET}\n"
  echo -e "Setting up the SERVER...\n"
  sudo docker exec -it clab-simple-SERVER sh -c ". tmp/lab_server.sh"
  echo -e "\nRunning command in the CLIENT side..."
  sleep 3
  sudo docker exec -it clab-simple-CLIENT sh -c ". tmp/lab_client.sh"
  echo -e "\n${BLUE}END OF THE LAB${RESET}"
elif [[ "$answer" == "no" ]]; then
  echo -e "\nOperation canceled."
else
  echo -e "\n${RED}Invalid input. Please answer with 'yes' or 'no'.${RESET}"
fi