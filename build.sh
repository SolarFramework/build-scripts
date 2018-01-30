#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo -e "Usage: build.sh <mode>"
    echo -e "mode: debug or release"
    exit
fi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/solarbuild.sh $1 buildall
