#!/bin/bash

sourcedir=$(dirname "$0")

set -eo pipefail



echo "setting up kubernetes-logging"

kubectl create namespace logging \
  --dry-run=client -o yaml | kubectl apply -f -

helm upgrade elk \
   -n logging --create-namespace \
   -f $sourcedir/k8s-logging-kind-values.yaml $sourcedir/.. \
   --install

for var in "$@"
do
    if [[ "$var" = "--with-lb" ]]; then
      echo "creating kibana LoadBalancer"
      
      kubectl expose svc/elk-kibana \
        -n logging --name elk-kibana-lb --type=LoadBalancer \
        --port 5601 --target-port=5601 \
        --dry-run=client -o yaml | kubectl apply -f -

      echo "creating es LoadBalancer"
      
      kubectl expose svc/elk-client \
        -n logging --name elk-client-lb --type=LoadBalancer \
        --port 9200 --target-port=9200 \
         --dry-run=client -o yaml | kubectl apply -f -
    fi

    if [[ "$var" = "--templates" ]]; then
      echo " generate helm templates"
      
      helm template elk -n logging \
        -f $sourcedir/k8s-logging-kind-values.yaml $sourcedir/.. \
        > $sourcedir/templates.yaml
    fi


done      