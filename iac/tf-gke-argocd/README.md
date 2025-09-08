
# Terraform: GKE (1 node) + Argo CD (LB) + Sample App (LB)

This project creates a minimal **zonal** GKE cluster with **1 node**, installs **Argo CD** via Helm in its own namespace (`argocd`), and deploys a tiny **nginx** example Service exposed to the public internet via a **LoadBalancer**. Argo CD's server Service is also exposed via a GCP load balancer.

## Prereqs
- Terraform >= 1.5
- Google Cloud project with billing enabled
- Permissions to create GKE + networking + service accounts
- `gcloud` CLI authenticated to the target project

## Quick start
```bash
# 1) Set your vars
terraform init
terraform apply -auto-approve   -var="project_id=YOUR_PROJECT_ID"   -var="region=us-central1"   -var="zone=us-central1-a"   -var="cluster_name=demo-gke-1"

# 2) (optional) Fetch kubeconfig for kubectl
gcloud container clusters get-credentials $(terraform output -raw cluster_name) --zone $(terraform output -raw zone) --project $(terraform output -raw project_id)

# 3) Grab Argo CD LB address
terraform output argocd_server_ip

# 4) Get initial Argo CD admin password (first run only)
# Terraform tries to read it for you; if it's empty, wait a minute and re-run:
terraform output argocd_initial_admin_password

# 5) Example app public IP
terraform output example_app_ip
```

## What this does
- Creates a GKE standard (non-Autopilot) **zonal** cluster with 1-node nodepool
- Installs Argo CD via Helm into `argocd` namespace and exposes it with `Service: LoadBalancer`
- Deploys a sample `Deployment` + `Service: LoadBalancer` (nginx) to validate public access

> Note: Creating GCP load balancers can take a few minutes. Terraform resources are configured to wait for LB assignment.

## Cleanup
```bash
terraform destroy
```
