#!/bin/bash -xe
nvm install --lts
curl -sL https://github.com/DanyBittan/Node/archive/main.zip --output main.zip
sudo apt install unzip
unzip main.zip
cd Node-main/Node
npm i