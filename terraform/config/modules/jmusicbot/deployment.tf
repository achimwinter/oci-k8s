resource "kubernetes_deployment" "jmusicbot_deployment" {
  metadata {
    name = "jmusicbot-deployment"
    labels = {
      App = "JMusicBot"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "JMusicBot"
      }
    }

    template {
      metadata {
        labels = {
          app = "JMusicBot"
        }
      }

      spec {
        volume {
          name = "config-volume"
          config_map {
            name = kubernetes_config_map.jmusic_config.metadata[0].name
          }

        }

        container {
          image = "craumix/jmusicbot:0.4.3"
          name  = "jmusicbot-container"

          volume_mount {
            mount_path        = "/jmb/config/config.txt"
            mount_propagation = "None"
            name              = "config-volume"
            sub_path          = "config.txt"
            read_only         = false
          }

          env {
            name  = "CONFIG_PATH"
            value = "/jmb/config/config.txt"
          }
        }
      }
    }
  }
}
