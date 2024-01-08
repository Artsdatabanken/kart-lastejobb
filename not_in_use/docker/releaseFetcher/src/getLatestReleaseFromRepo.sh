#!/bin/bash

# $1 = repo/project
# $2 = fileName
# $3 = folder
# $4 = unzip/tar

latestRelease=`curl --silent "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`

latestReleaseUrl=https://github.com/$1/releases/download/$latestRelease/$2

curl -L $latestReleaseUrl -o $3/$2

if [ "$#" -eq 4 ]; then
    tar xvzf $3/$2 -C $3

    rm $3/$2
fi

