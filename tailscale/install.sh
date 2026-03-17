#! /bin/bash

# https://tailscale.com/docs/features/kubernetes-operator for instructions on getting these

if [ -z $TS_OAUTH_CLIENT_ID ]; then
	echo "TS_OAUTH_CLIENT_ID unset; set it to continue"
	exit 1
fi
if [ -z $TS_OAUTH_CLIENT_SECRET ]; then
	echo "TS_OAUTH_CLIENT_SECRET unset; set it to continue"
	exit 1
fi
helm repo add tailscale https://pkgs.tailscale.com/helmcharts

helm repo update

helm upgrade \
  --install \
  tailscale-operator \
  tailscale/tailscale-operator \
  --namespace=tailscale \
  --create-namespace \
  --set operatorConfig.logging=debug \
  --set-string oauth.clientId=$TS_OAUTH_CLIENT_ID \
  --set-string oauth.clientSecret=$TS_OAUTH_CLIENT_SECRET \
  --wait
