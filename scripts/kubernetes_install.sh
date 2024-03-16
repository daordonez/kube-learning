#!/bin/bash

echo "Kubernetes installation script for: Kubernetes v1.29"

#1. Install CAs and GPG key
sudo apt-get --assume-yes install -y apt-transport-https ca-certificates curl gpg

#2.Download de public signing key for the Kubernetes package repositories.
#2.1 Verify whether /etc/apt/keyrings exists or not
if [ ! -d "/etc/apt/keyrings"]; then
    sudo mkdir -p -m 755 /etc/apt/keyrings
else
    echo "Public keyrings directory found"
fi

#2.2 Add public key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg


#3. Add Kubernetes apt repository
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


#4. Update the apt package index, install kubelet, kubeadm and kubctl
sudo apt-get update
sudo apt-get --assume-yes install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

#4. Enable kubelet service
sudo systemctl enable --now kubelet