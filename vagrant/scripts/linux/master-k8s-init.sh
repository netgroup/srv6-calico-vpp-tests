#!/bin/bash

set -x
kubeadm reset -f

KUBERNETES_VERSION=$1
MASTER_IP=$2
MASTER_IP6=$3
POD_NW_CIDR=$4 
SERVICE_CIDR=$5
KUBETOKEN=$6

retries=5
for ((i = 0; i < retries; i++)); do
    # For now ignore SystemVerification error
    kubeadm init \
        --kubernetes-version="${KUBERNETES_VERSION}" \
        --ignore-preflight-errors=SystemVerification \
        --apiserver-advertise-address="${MASTER_IP}" \
        --apiserver-cert-extra-sans="${MASTER_IP}","${MASTER_IP6}" \
        --pod-network-cidr="${POD_NW_CIDR}" \
        --service-cidr="${SERVICE_CIDR}" \
        --token "${KUBETOKEN}" \
        --token-ttl 0 &&
        break
    echo "kubeadm join failed, trying again in 3 seconds (try ${i}/${retries})..."
    sleep 3
done
[[ $retries -eq i ]] && {
    echo "Failed to run kubeadm init after 5 tries"
    exit 1
}

mkdir -p "$HOME"/.kube
cp -Rf /etc/kubernetes/admin.conf "$HOME"/.kube/config
chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc # add autocomplete permanently to your bash shell.
