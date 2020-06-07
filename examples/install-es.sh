#!/bin/bash

sourcedir=$(dirname "$0")

set -eo pipefail

echo "setting up kubernetes-logging"

kubectl create namespace logging \
  --dry-run=client -o yaml | kubectl apply -f -

rm -f $sourcedir/templates.yaml

#generated templates
helm template elk \
   -n logging --create-namespace \
   -f $sourcedir/k8s-logging-values.yaml $sourcedir/.. \
    --wait --timeout 15m --debug > $sourcedir/templates.yaml

helm upgrade elk \
   -n logging --create-namespace \
   -f $sourcedir/k8s-logging-values.yaml $sourcedir/.. \
   --install --wait --timeout 15m --debug

kubectl expose svc/elk-client -n logging \
  --name es --port 9200 --target-port=9200 --type LoadBalancer \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl expose svc/elk-kibana -n logging \
  --name kibana --port 5601 --target-port=5601 --type LoadBalancer \
  --dry-run=client -o yaml | kubectl apply -f -

