#!/usr/bin/env bash

main () {
    shell=$(ps -o comm= $$)
    echo $shell;
    if [[ ${shell} = 'zsh' ]]; then
        echo "Actually running ZSH";
        return 0;
    fi

    # try to start zsh or install it.
    which zsh > /dev/null

    if [[ $? -eq 0 ]]; then
        echo "ZSH found";
        return 1;
    fi;

    return 2;
}

main
