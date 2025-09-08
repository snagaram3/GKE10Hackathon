
# Minimal public example to prove LB works
resource "kubernetes_namespace" "example" {
  provider = kubernetes.gke
  metadata { name = "example" }
}

resource "kubernetes_deployment" "nginx" {
  provider = kubernetes.gke
  metadata {
    name      = "hello-nginx"
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = { app = "hello-nginx" }
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "hello-nginx" } }
    template {
      metadata { labels = { app = "hello-nginx" } }
      spec {
        container {
          name  = "nginx"
          image = "nginx:1.25-alpine"
          port { container_port = 80 }
        }
      }
    }
  }

  depends_on = [google_container_node_pool.primary_nodes]
}

resource "kubernetes_service" "nginx_lb" {
  provider = kubernetes.gke
  metadata {
    name      = "hello-nginx"
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = { app = "hello-nginx" }
  }
  spec {
    selector = { app = "hello-nginx" }
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }

  # Tell Terraform to wait until the LB IP is assigned
  wait_for_load_balancer = true

  depends_on = [kubernetes_deployment.nginx]
}
