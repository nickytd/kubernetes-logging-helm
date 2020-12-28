#!/bin/bash


if ! command -v kind &> /dev/null
then
    echo "get kind https://kind.sigs.k8s.io"
    exit
fi

if ! command -v kubectl &> /dev/null
then
    echo "get kubectl https://kubernetes.io/docs/tasks/tools/install-kubectl/"
    exit
fi

echo "create cluster"
kind create cluster --name kind --config kind-config.yaml

kubectl cluster-info --context kind-kind

echo "deploy nginx-ingress controler"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml