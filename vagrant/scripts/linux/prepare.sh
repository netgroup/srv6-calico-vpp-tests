#!/bin/bash
DATA_IF_MTU=$1
NODE_IP=$2  # IP address of the node
NODE_IP6=$3  # IP6 address of the node
NODE_IP6_GATEWAY=$4  # Gateway IP6 of the node
NODE_IP4_GATEWAY=$5  # Gateway IP6 of the node
NODE_IP4_NET=$6  # Gateway IP6 of the node
resize2fs /dev/vda3

second_if=$(ip -o link show | awk -F': ' '{print $2}' |grep -v -e lo -e docker -e eth0)
echo "Using ${second_if} as k8s interface"

cat <<EOF > /etc/netplan/99-calicovpp.yaml
---
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      mtu: 1380
    ${second_if}:
      mtu: ${DATA_IF_MTU}
      accept-ra: false
      addresses:
        - ${NODE_IP}/24
        - ${NODE_IP6}/64
      routes:
        - to: ::/0
          via: ${NODE_IP6_GATEWAY}
          table: 0
        - to: ${NODE_IP4_NET}
          via: ${NODE_IP4_GATEWAY}
          table: 0
EOF

netplan apply

KUBELET_EXTRA_ARGS_FILE=/etc/default/kubelet
echo "KUBELET_EXTRA_ARGS=--node-ip=${NODE_IP} --cni-bin-dir=/opt/cni/bin,/usr/libexec/cni" > "${KUBELET_EXTRA_ARGS_FILE}"
systemctl enable kubelet
systemctl start kubelet

# if image file exists
if [ -f /tmp/image_vpp_srv6 ]; then
  # load cri image
  ctr -n k8s.io image import --base-name zvfvrv/vpp:latest /tmp/image_vpp_srv6 
  # done
  rm -f /tmp/image_vpp_srv6
fi

#if image agent file exists
if [ -f /tmp/image_agent_srv6 ]; then
  # load crio image
  ctr -n k8s.io image import --base-name zvfvrv/agent:latest /tmp/image_agent_srv6
  # done
  rm -f /tmp/image_agent_srv6
fi
