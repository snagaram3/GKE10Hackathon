
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "default" {}

# K8s provider wired to the new GKE cluster
provider "kubernetes" {
  host                   = "https://${google_container_cluster.gke.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token

  # ensure we don't try to talk to k8s until it's ready
  alias = "gke"
}

# Helm provider using the same Kubernetes connection
provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.gke.endpoint}"
    cluster_ca_certificate = base64decode(google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}
