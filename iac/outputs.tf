output "cluster_name" {
  description = "The name of the GKE cluster."
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster."
  value       = google_container_cluster.primary.endpoint
}

output "argocd_server_ip" {
  description = "The external IP address of the Argo CD server."
  value = kubernetes_service.argocd_server.status.0.load_balancer.0.ingress.0.ip
  depends_on = [
    helm_release.argocd
  ]
}

resource "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
}