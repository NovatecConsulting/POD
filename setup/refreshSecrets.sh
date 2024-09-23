#!/bin/bash

#create secrets. This assumes you have a secrets dir at top level where the real secrets reside.
kubectl create secret generic argocd-secret -n argocd --dry-run=client --from-env-file ../secrets/argocd.properties -o yaml > /tmp/argocd.yaml
kubeseal -f /tmp/argocd.yaml -w ./argocd/sealed-app-registration-secret.yaml

kubectl create secret generic azuredns-config -n cert-manager --dry-run=client --from-env-file ../secrets/cert-manager.properties -o yaml > /tmp/cert.yaml
kubeseal -f /tmp/cert.yaml -w ./cert-manager/sealed-client-secret.yaml

kubectl create secret generic azure-secret -n crossplane --dry-run=client --from-file creds=../secrets/crossplane.json -o yaml > /tmp/crossplane.yaml
kubeseal -f /tmp/crossplane.yaml -w ./crossplane/sealed-service-principle.yaml

kubectl create secret generic azure-config-file -n external-dns --dry-run=client --from-file creds=../secrets/external-dns.json -o yaml > /tmp/external-dns.yaml
kubeseal -f /tmp/crossplane.yaml -w ./external-dns/sealed-azure-config.yaml