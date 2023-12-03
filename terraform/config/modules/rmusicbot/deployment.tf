resource "kubernetes_namespace" "rmusicbot" {
  metadata {
    name = "rmusicbot"
  }
}

resource "kubernetes_deployment" "rmusicbot_deployment" {
  metadata {
    name = "rmusicbot-deployment"
    labels = {
      App = "RMusicBot"
    }
    namespace = kubernetes_namespace.rmusicbot.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "RMusicBot"
      }
    }

    template {
      metadata {
        labels = {
          app = "RMusicBot"
        }
      }

      spec {
        container {
          image = "blackduster/rmusicbot:latest"
          name  = "rmusicbot-container"

          image_pull_policy = "Always"

          env {
            name  = "DISCORD_TOKEN"
            value = "${base64decode(data.oci_secrets_secretbundle.rmusic_token.secret_bundle_content.0.content)}"
          }
          env {
            name  = "PREFIX"
            value = "+"
          }
          env {
            name  = "DISCORD_STATUS"
            value = "Yellow Mellow"
          }
        }
      }
    }
  }
}
