#!/bin/bash

sourcedir=$(dirname "$0")

set -eo pipefail


if [[ "$1" == "-h" ]]; then
   echo "### installs kubernetes logging stack ###"
   echo "   supported options:"
   echo "     --scaled"
   echo "         provisions multi node elastisearch with kafka and fluentd"
   echo "     --with-templates"
   echo "         saves helm generated deployment manifests"
   echo "     --with-exporter"
   echo "         adds elastic logging prometheus exporter" 
   exit
fi

echo "setting up kubernetes-logging"

kubectl create namespace logging \
  --dry-run=client -o yaml | kubectl apply -f -

if [ -d "$sourcedir/ssl" ]; then
  echo "setting up tls secrtes"
  certs=("opensearch-dashboards" "os")
  for c in ${certs[@]}; do
    kubectl create secret tls "$c-tls" -n logging \
      --cert=$sourcedir/ssl/wildcard.crt \
      --key=$sourcedir/ssl/wildcard.key \
      --dry-run=client -o yaml | kubectl apply -f - 
  done 
fi 

values="single-node-setup.yaml"
for var in "$@"
do
    if [[ "$var" = "--scaled" ]]; then
      values="multi-node-ha-setup.yaml"
    fi
done    

helm upgrade efk \
    -n logging --create-namespace \
    -f "$sourcedir/$values" $sourcedir/../charts \
    --install --wait-for-jobs --timeout=30m

for var in "$@"
do    

    if [[ "$var" = "--with-templates" ]]; then
      echo " generating helm templates"
      
      helm template efk -n logging \
        -f "$sourcedir/$values" $sourcedir/../charts \
        > $sourcedir/templates.yaml 
    fi
    
    if [[ "$var" = "--with-exporter" ]]; then
      echo " installing opensearch prometheus exporter"

      kubectl create secret generic opensearch-certs -n logging \
        --from-file=ca.pem=$sourcedir/../charts/certificates/ca/root-ca/root-ca.pem \
        --dry-run=client -o yaml | kubectl apply -f -

      helm upgrade efk-exporter \
        -n logging --create-namespace  -f "$sourcedir/opensearch-exporter.yaml" \
        prometheus-community/prometheus-elasticsearch-exporter \
        --install
    fi

done      