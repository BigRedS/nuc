#! /bin/bash

helm repo add blakeblackshear https://blakeblackshear.github.io/blakeshome-charts/

helm upgrade \
  --install \
	--namespace frigate \
	--create-namespace \
	frigate \
	blakeblackshear/frigate \
	-f values.yaml
