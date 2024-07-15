# POD
Plattform for Orchestation and Deployment - A modern Cloud Plattform based on Open Source technology

## Idea
POD is a playground to learn and discover new technology. For now, the initial setup is in progress.
The general idea is to dive deepe into the Kubernetes based ecosystem as well as using GitOps

## Components and current plan
![Diagram showing the components of POD and how they work together](./POD.svg)

## Setup
To automate the setup as much as possible, the bootstrapping of the cluster uses [ArgoCD - Application of Applications](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/). With this, only ArgoCD has to be installed and the [application](./setup/setup.yaml) has to be created. In the [setup directory](./setup/) all needed Application definitions are found and then automatically synched by ArgoCD. Also all routes, config maps are created. Currently, you only need to bring your own cluster, which will be automated soon™. 

### Manual Setup Steps
The sealed secrets can't be applied on another Kubernetes, as the controller can't unencrypt them. To fix this, recreate sealed secrets with `kubeseal` and check them into the repository, ArgoCD will synch them automatically.

## Decisions currently made

### ArgoCD: Run without TLS
ArgoCD is setup to not use any certificate (also not the sef signed one). As TLS Passthrough is a experimental feature of the Gateway API, TLS termination currently happens in the Gateway and not in the App 

### Tekton: Use of Tekton Operator instead of individual depolyment
Since one of the main goals is to automate the setup of all these components, the decision was made to use the Tekton Operator and deploy all needed 

### Contour: Use of Contour and Gateway AP together with Gateway-provisioner
Besides the goal to automate stuff, one of the goals of POD is to use active projects in the CNCF, especially projects that are at least incubating. Contour is such a project and the possibility to automatically add routes without restarting any ingress pod and having a clear config without the need of anotations thatnks to the Gateway API lead to this selection

### SealedSecrets: Allow Secrets to be in git
Since a lot of this setup is build on top of GitOps principles, I wanted to allow the use of Secrets in repositories. Since without any setup, this is not possible, the reasonable way to do this is using SealedSecrets.

### DNS Setup and TLS
A Wildcard certificate is setup using cert-manager. TLS termination happens at the Gateway, NOT in each app. This is ue to the fact, that
- TLS Passthrough is an experimental feature of the Gateway API
- Not all Apps suport TLS setup on their own (for example Tekton Dashboards)

### DNS Management: Use of ExternalDNS instead of Crossplane
Crossplane in this setup allows to create cloud resources, and could be used to setup DNS A Records. But the limits are reached quite quickly: Its not fully automated as the Gateway IP adress can not easily be set in the a-records resources automatically. Instead for this part, ExternalDNS is used

