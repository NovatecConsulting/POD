#! /bin/bash

set -e

# Install ArgoCD on current Cluster
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Setup this repo as Argo Project which will automatically create the Projects for all other tools
kubectl apply -f setup.yaml