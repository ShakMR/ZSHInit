#!/usr/bin/env zsh

ZDOTDIR=${HOME}

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR}/.${rcfile:t}"
done

prompt -s iggy

