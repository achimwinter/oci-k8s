resource "kubectl_manifest" "vaultwarden_db_credentials" {
  depends_on = [kubectl_manifest.vaultwarden_namespace]

  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: vaultwarden-db-credentials
  namespace: vaultwarden
type: Opaque
stringData:
  username: vaultwarden
  password: ${base64decode(data.oci_secrets_secretbundle.vaultwarden_db_password.secret_bundle_content.0.content)}
YAML
}

resource "kubectl_manifest" "vaultwarden_admin_token" {
  depends_on = [kubectl_manifest.vaultwarden_namespace]

  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: vaultwarden-admin-token
  namespace: vaultwarden
type: Opaque
stringData:
  ADMIN_TOKEN: ${base64decode(data.oci_secrets_secretbundle.vaultwarden_admin_token.secret_bundle_content.0.content)}
YAML
}

