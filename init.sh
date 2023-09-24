#! /bin/bash

echo "> Installing k3s"
# Install k3s
if ps aux | grep -q 'k[3]s'; then
  echo "k3s already installed"
else
  export K3S_KUBECONFIG_MODE="644" export INSTALL_K3S_EXEC=" --disable servicelb --disable traefik"
  curl -sfL https://get.k3s.io | sudo sh -
fi

mkdir -p ~/.kube/
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
kubectl get nodes

echo "> Installing Argocd"
echo;echo
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "> Logging in to argo"
argocd login --core

kubectl config set-context --current --namespace=argocd
sleep 10
echo "> Adding argo app"
argocd app create app-of-apps --dest-namespace argocd --dest-server https://kubernetes.default.svc --repo https://github.com/BigRedS/nuc --path apps
argocd app set argocd/app-of-apps --sync-policy automated
argocd app sync argocd/app-of-apps

# s# leep 5
echo "> Installing metallb"
argocd app set argocd/metallb --sync-policy automated
argocd app sync argocd/metallb
 
echo "> Waiting for syncing"
sleep 10

echo "> Configuring metallb"
kubectl create namespace metallb
kubectl -n metallb apply -f ./manifests/IPAddressPool.yaml
kubectl -n metallb apply -f ./manifests/L2Advertisement.yaml

echo "> Patching argo service"
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

echo "> Getting argo password"
argocd admin initial-password -n argocd
