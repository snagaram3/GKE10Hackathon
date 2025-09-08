resource "kubernetes_namespace" "argocd" {
  provider = kubernetes.gke
  metadata {
    name = "argocd"
  }
}

# Install Argo CD via Helm; expose server via LoadBalancer
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.6.12" # pin a recent chart version

  wait    = true
  timeout = 1200

  values = [yamlencode({
    server = {
      service = {
        type = "LoadBalancer"
      }
    }
    controller     = { replicas = 1 }
    repoServer     = { replicas = 1 }
    applicationSet = { replicas = 1 }
  })]

  depends_on = [kubernetes_namespace.argocd]
}

# Data source to read the Argo CD server Service
data "kubernetes_service" "argocd_server" {
  provider = kubernetes.gke
  metadata {
    name      = "argocd-server"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
  depends_on = [helm_release.argocd]
}

# Convenience: read initial admin password (created on first install)
data "kubernetes_secret" "argocd_admin" {
  provider = kubernetes.gke
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
  depends_on = [helm_release.argocd]
}
