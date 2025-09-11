
# Minimal, standard (non-Autopilot) GKE cluster using default VPC/subnet
resource "google_container_cluster" "gke" {
  name               = var.cluster_name
  location           = var.zone
  network            = "default"
  subnetwork         = "default"
  remove_default_node_pool = true
  initial_node_count = 1

  release_channel {
    channel = "REGULAR"
  }

  # VPC-native (IP alias) — required for modern GKE; empty block enables defaults
  ip_allocation_policy {}

  lifecycle {
    ignore_changes = [node_config, node_pool]
  }
}

# Single-node pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-nodepool"
  cluster    = google_container_cluster.gke.name
  location   = var.zone

  node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    labels = {
      env = "dev"
    }
  }

  depends_on = [google_container_cluster.gke]
}
