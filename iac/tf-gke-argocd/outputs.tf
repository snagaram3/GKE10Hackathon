output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}

output "zone" {
  value = var.zone
}

output "cluster_name" {
  value = google_container_cluster.gke.name
}

output "cluster_endpoint" {
  value       = google_container_cluster.gke.endpoint
  description = "GKE master endpoint (internal to the control plane)"
}

# Argo CD public IP (once LB is provisioned)
output "argocd_server_ip" {
  value = try(
    data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].ip,
    null
  )
  description = "Argo CD Server LoadBalancer IP (null until provisioned)"
}

# Read initial admin password (may be null briefly right after install)
output "argocd_initial_admin_password" {
  value       = try(base64decode(data.kubernetes_secret.argocd_admin.data.password), null)
  sensitive   = true
  description = "Initial 'admin' password for Argo CD (rotate after first login)"
}

# Example app public IP
output "example_app_ip" {
  value = try(
    kubernetes_service.nginx_lb.status[0].load_balancer[0].ingress[0].ip,
    null
  )
  description = "Public IP for the sample nginx Service: LoadBalancer"
}
