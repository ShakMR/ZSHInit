#!/usr/bin/env bash

checkSystemInstallComm() {
    systemName=$(uname)

    if [[ ${systemName} = 'Darwin' ]]; then
        which brew > /dev/null
        if [[ $? -eq 0 ]]; then
            echo 'brew install';
        fi
        echo 'Please, install brew first';
        return 1;
    elif [[ ${systemName} = 'Linux' ]]; then
        echo 'sudo apt install'
    fi
}

installZsh() {
    installComm=$(checkSystem)
    if [[ $? -eq 0 ]]; then
        ${installComm} zsh
    fi
}

installZsh

chsh -s /bin/zsh
