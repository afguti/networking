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
    echo -e "\nStarting LAB with: source $(ls -d *env)/bin/activate\n"
    . 3way_env/bin/activate
    export PS1="($(ls -d *env)) \[\e[32m\]./\W $\[\e[0m\] "
}

function get() {
    local upper_arg="${1^^}"
    echo "Executing: docker exec -it clab-${name}-${upper_arg} sh -l"
    docker exec -it "clab-simple-${upper_arg}" sh -l
}






