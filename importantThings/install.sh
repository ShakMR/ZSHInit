#!/usr/bin/env zsh

rm -rf build
mkdir build && \
g++ --std=c++14 -o ./build/enigmatic.x enigmatic.cpp && \
cp important.sh ./build && \
mkdir -p ~/.important && \
cp -a ./build/. ~/.important && \

echo "Copy this to your environtment file" && \
echo "source ~/.important/important.sh" && \
echo "export PATH=~/.important/:\$PATH" && \
