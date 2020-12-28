#!/bin/bash

sourcedir=$(dirname "$0")

set -eo pipefail

templates=$1

echo "setting up kubernetes-logging"

kubectl create namespace logging \
  --dry-run=client -o yaml | kubectl apply -f -

rm -f $sourcedir/templates.yaml

if [ ! -z ${templates} ]; then
  echo " generate helm templates"
  helm template elk \
     -n logging --create-namespace \
     -f $sourcedir/k8s-logging-kind-values.yaml $sourcedir/.. \
     > $sourcedir/${templates}
fi

helm upgrade elk \
   -n logging --create-namespace \
   -f $sourcedir/k8s-logging-kind-values.yaml $sourcedir/.. \
   --install


kubectl apply -f elk-ingresses.yaml \
  --dry-run=client -o yaml | kubectl apply -f -

