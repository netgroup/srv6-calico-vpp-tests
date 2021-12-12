#!/bin/bash
NAME=$1
NS_PID=$(ps ax | grep mininet:"$NAME" | grep bash | awk {'print $1'})
if [ -z "$NS_PID" ]; then
    echo "No namespace found for $NAME"
    exit 1
fi
echo "Entering namespace $NAME"
sudo nsenter -t "$NS_PID" -n -m --
