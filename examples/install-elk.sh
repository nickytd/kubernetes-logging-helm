#!/bin/bash

sourcedir=$(dirname "$0")

set -eo pipefail

type=$1

if [[ $type == "-kind" ]] || [[ $type == "-minikube" ]]; then
   echo "runtime $type"
else 
  echo "usage install-elk.sh -kind or install-elk.sh -minikube"
  exit 0
fi

echo "setting up kubernetes-logging"

kubectl create namespace logging \
  --dry-run=client -o yaml | kubectl apply -f -

if [ -d "$sourcedir/ssl" ]; then
  echo "setting up tls secrtes"
  certs=("kibana" "es")
  for c in ${certs[@]}; do
    kubectl create secret tls "$c-tls" -n logging \
      --cert=$sourcedir/ssl/wildcard.crt \
      --key=$sourcedir/ssl/wildcard.key \
      --dry-run=client -o yaml | kubectl apply -f - 
  done 
fi    

helm upgrade elk \
   -n logging --create-namespace \
   -f "$sourcedir/k8s-logging$type-values.yaml" $sourcedir/../charts \
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
        -f $sourcedir/k8s-logging-kind-values.yaml $sourcedir/../charts \
        > $sourcedir/templates.yaml 
    fi

    if [[ "$var" = "--with-exporter" ]]; then
      echo " installing elasticsearch prometheus exporter"

      kubectl create secret generic elastic-certs -n logging \
        --from-file=ca.pem=$sourcedir/../charts/certificates/ca/root-ca/root-ca.pem \
        --dry-run=client -o yaml | kubectl apply -f -

      helm upgrade elk-exporter \
        -n logging --create-namespace  -f "$sourcedir/elasticsearch-exporter.yaml" \
        prometheus-community/prometheus-elasticsearch-exporter \
        --install
    fi

done      