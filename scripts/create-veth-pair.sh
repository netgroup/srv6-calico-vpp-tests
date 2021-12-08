#!/bin/bash

# connect a veth device inside an anonymous network namespace to one outiside

HOST=$1
INDEX=$2
NETNS_PID=$(ps ax | grep mininet:$HOST | grep bash | awk '{print $1}')
VM_NAME=$3
VM_PREFIX_NET=$4
VETH_NS_IP6=$5
VETH_NS_IP4=$6
VETH_NS_NAME="veth${HOST}${INDEX}"

NET_NAME=$(sudo virsh domiflist $VM_NAME | grep $VM_PREFIX_NET | awk '{print $3}')
V_SWITCH=$(sudo virsh net-info $NET_NAME | grep Bridge | awk '{print $2}')
echo "$NET_NAME $V_SWITCH"
sudo nsenter -t "$NETNS_PID" -n -m -- ip link add $VETH_NS_NAME type veth peer name $VETH_NS_NAME netns 1
sudo ip link set $VETH_NS_NAME up
# connect the veth0 to L2 switch
sudo ip link set $VETH_NS_NAME master $V_SWITCH
# activate veth0 inside the NS
sudo nsenter -t "$NETNS_PID" -n -m -- ip link set $VETH_NS_NAME up
# assign IP6 to the veth0 inside the NS
sudo nsenter -t "$NETNS_PID" -n -m -- ip addr add $VETH_NS_IP6 dev $VETH_NS_NAME
# assign IP4 to the veth0 inside the NS
sudo nsenter -t "$NETNS_PID" -n -m -- ip addr add $VETH_NS_IP4 dev $VETH_NS_NAME

