#!/bin/sh

HOST="$1"
until $(curl --output /dev/null --silent --head --fail $HOST); do
    printf "Waiting for $1 to be up\n"
    sleep 1
done