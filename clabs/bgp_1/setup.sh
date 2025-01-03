#!/usr/bin/bash

# Check if yq is installed, if not, install it
if ! command -v yq &> /dev/null
then
    echo "**** yq NOT FOUND, INSTALLING NEEDED PACKAGES ****"
    sudo apt update
    sudo apt install yq -y
else
    echo "**** yq IS ALREADY INSTALLED ****"
fi

echo "**** SETING UP THE ENVIRONMENT ****"

alias inspect='sudo clab inspect'

alias deploy='sudo clab deploy'

alias destroy='sudo clab destroy'

alias rebuild='sudo clab destroy; sudo clab deploy'

alias lab='. ./scripts/lab.sh'

alias exit='deactivate'

name=$(yq -e '.name' *clab.yml | tr -d '"')

function begin() {
    echo -e "\nStarting LAB with: source $(ls -d *venv)/bin/activate\n"
    . $(ls -d *venv)/bin/activate
    export PS1="($(ls -d *env)) \[\e[32m\]./\W $\[\e[0m\] "
}

function get() {
    local upper_arg="${1^^}"
    echo "Executing: docker exec -it clab-${name}-${upper_arg} sh -l"
    docker exec -it "clab-${name}-${upper_arg}" sh -l
}

#I think I dont need this function because of bind mount in the yaml file
function frrcp() {
    local upper_arg="${1^^}"
    docker cp "clab-${name}-${upper_arg}/etc/frr/frr.conf" "./frr-configs/frr-${1,,}.conf"
}

function menu() {
    echo -e "\n${GREEN}begin${RESET} - Activate the virtual environment"
    echo -e "${GREEN}get${RESET} - Get a shell in the container"
    echo -e "${GREEN}deploy${RESET} - deploy topology.clab.yml"
    echo -e "${GREEN}destroy${RESET} - destroy topology.clab.yml"
    echo -e "${GREEN}rebuild${RESET} - destroy and deploy topology.clab.yml"
    echo -e "${GREEN}inspect${RESET} - inspect topology.clab.yml"
    echo -e "${GREEN}lab${RESET} - source scripts/lab.sh (deploy the whole lab)"
    echo -e "${GREEN}exit${RESET} - deactivate the virtual environment"
    echo -e "${GREEN}help${RESET} - Display this help message\n"
}




