resource "kubernetes_config_map" "jmusic_config" {
  metadata {
    name = "jmusic-config"
  }

  data = {
    "config.txt" = <<-EOT
      token  = "${base64decode(data.oci_secrets_secretbundle.jmusic_token.secret_bundle_content.0.content)}"
      owner  = "${base64decode(data.oci_secrets_secretbundle.jmusic_owner.secret_bundle_content.0.content)}"
      prefix = "!"
      EOT
  }
}
