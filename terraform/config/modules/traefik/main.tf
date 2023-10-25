resource "kubernetes_deployment" "traefik" {
  metadata {
    name = "traefik"
    labels = {
      k8s-app = "traefik"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        k8s-app = "traefik"
      }
    }
    template {
      metadata {
        labels = {
          k8s-app = "traefik"
        }
      }
      spec {
        container {
          image = "traefik:v2.4"
          name  = "traefik"
          args = [
            "--api.insecure",
            "--accesslog",
            "--entrypoints.web.address=:80",
            "--providers.kubernetesingress"
          ]
        }
      }
    }
  }
}

resource "kubernetes_service" "traefik" {
  metadata {
    name = "traefik"
  }
  spec {
    selector = {
      k8s-app = "traefik"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

