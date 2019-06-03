#!/usr/bin/env bash

./checkZSH.sh

result=$?

if [[ ${result} -eq 1 ]]; then
    echo "Switching to zsh"
    zsh
elif [[ ${result} -eq 2 ]]; then
    ./installZSH.sh
fi
