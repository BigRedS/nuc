#! /bin/bash

kubectl -n frigate annotate svc frigate tailscale.com/expose=true
