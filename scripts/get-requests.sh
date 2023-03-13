#!/bin/bash

GATEWAYS=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" -n istio-system | grep ingress)

for i in $GATEWAYS; do 
    kubectl logs -n istio-system "$i" | grep ping.dev2.mlife
done