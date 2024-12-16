#!/bin/bash

#create secrets. This assumes you have a secrets dir at top level where the real secrets reside.
kubeseal -f ../secrets/argocd.yaml -w ./argocd/sealed-app-registration-secret.yaml
kubeseal -f ../secrets/certmanager.yaml -w ./cert-manager/sealed-client-secret.yaml
kubeseal -f ../secrets/crossplane.yaml -w ./crossplane/sealed-service-principle.yaml
kubeseal -f ../secrets/externaldns.yaml -w ./external-dns/sealed-azure-config.yaml