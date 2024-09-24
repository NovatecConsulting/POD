#! /bin/bash

set -e

# Install ArgoCD on current Cluster
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Enable patching of argocd secret from sealed secrets
# https://github.com/bitnami-labs/sealed-secrets?tab=readme-ov-file#patching-existing-secrets
kubectl annotate secret argocd-secret -n argocd sealedsecrets.bitnami.com/patch="true"

# Setup this repo as Argo Project which will automatically create the Projects for all other tools
kubectl apply -f setup.yaml

