#!/bin/bash

# add route localsid inside an anonymous network namespace

HOST=$1
INDEX=$2
NETNS_PID=$(ps ax | grep mininet:$HOST | grep bash | awk '{print $1}')
VM_NAME=$3
VM_PREFIX_NET=$4
SIDS_NET=$5
SIDS_VIA=$6
VETH_NS_NAME="veth${HOST}${INDEX}"

NET_NAME=$(sudo virsh domiflist $VM_NAME | grep $VM_PREFIX_NET | awk '{print $3}')
V_SWITCH=$(sudo virsh net-info $NET_NAME | grep Bridge | awk '{print $2}')
echo "$NET_NAME $V_SWITCH $SIDS_NET $SIDS_VIA"

# add route localsid
sudo nsenter -t "$NETNS_PID" -n -m -- ip route add $SIDS_NET via $SIDS_VIA dev $VETH_NS_NAME

