#!/bin/zsh

npm run build

cd extensions || exit

mkdir -p ../packed

# check if $1 folder exists, if exists zip it, print error otherwise
if [ -d $1 ]; then
  rm -f ../packed/$1.zip
  zip -r ../packed/$1.zip $1
else
  echo "Error: Extension with name $1 does not exist"
fi
