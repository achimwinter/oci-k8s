resource "kubectl_manifest" "nextcloud_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: nextcloud
YAML
}

resource "kubectl_manifest" "vaultwarden_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: vaultwarden
YAML
}

