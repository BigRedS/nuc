#! /bin/bash
master_node="nuc-1"

echo ">Installing dependencies"
apt-get install curl vim 

echo "> Getting token"
K3S_TOKEN=$(ssh avi@$master_node sudo -S cat /var/lib/rancher/k3s/server/node-token)

echo "> Got token: $K3S_TOKEN"

echo "> Installing k3s"
if ps aux | grep -q 'k[3]s'; then
	echo "k3s already installed"
	exit 1
else
	export K3S_TOKEN=$K3S_TOKEN
	export K3S_URL=https://$master_node:6443
	curl -sfL https://get.k3s.io | sh -
fi
