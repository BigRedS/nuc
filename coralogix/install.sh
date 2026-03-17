#! /bin/bash

if kubectl -n coralogix get secret coralogix-keys 2>/dev/null >/dev/null ; then 
  echo "coralogix-keys secret exists already, leaving it"
else
  if [ -z $CX_API_KEY ]; then
    echo "CX_API_KEY unset; set it to continue"
    exit 1
  else
    kubectl create --namespace coralogix secret generic coralogix-keys --from-literal=PRIVATE_KEY="$CX_API_KEY"
  fi
fi


helm repo add coralogix https://cgx.jfrog.io/artifactory/coralogix-charts-virtual
helm repo update


helm upgrade --install otel-coralogix-integration coralogix/otel-integration \
	--namespace coralogix \
	--create-namespace \
	--render-subchart-notes \
	--values ./values.yaml
