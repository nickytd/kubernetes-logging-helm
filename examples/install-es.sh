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
   --debug > $sourcedir/templates.yaml

helm upgrade elk \
   -n logging --create-namespace \
   -f $sourcedir/k8s-logging-values.yaml $sourcedir/.. \
   --install

