#! /bin/bash

echo "> Installing k3s"
# Install k3s
#if ps aux | grep -q 'k[3]s'; then
#  echo "k3s already installed"
#else
  export K3S_KUBECONFIG_MODE="644" 
  export INSTALL_K3S_EXEC=" --disable servicelb --disable traefik"
  curl -sfL https://get.k3s.io | sudo sh -
#fi

mkdir -p ~/.kube/
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
kubectl get nodes
