#!/usr/bin/bash

echo "**** SETING UP THE ENVIRONMENT ****"

alias inspect='sudo clab inspect'

alias deploy='sudo clab deploy'

alias destroy='sudo clab destroy'

alias rebuild='sudo clab destroy; sudo clab deploy'

alias lab='. ./scripts/lab.sh'

function begin() {
    echo -e "\nStarting LAB with: source $(ls -d *env)/bin/activate\n"
    . 3way_env/bin/activate
    export PS1="($(ls -d *env)) \[\e[32m\]./\W $\[\e[0m\] "
}

alias exit='deactivate'

function get() {
    local upper_arg="${1^^}"
    echo "Executing: docker exec -it clab-simple-${upper_arg} sh -l"
    docker exec -it "clab-simple-${upper_arg}" sh -l
}





