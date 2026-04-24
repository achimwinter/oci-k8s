resource "kubectl_manifest" "nextcloud_credentials" {
  depends_on = [kubectl_manifest.nextcloud_namespace]

  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: nextcloud-credentials
  namespace: nextcloud
type: Opaque
stringData:
  nextcloud-username: ${base64decode(data.oci_secrets_secretbundle.nextcloud_username.secret_bundle_content.0.content)}
  nextcloud-password: ${base64decode(data.oci_secrets_secretbundle.nextcloud_password.secret_bundle_content.0.content)}
  db-username: ${base64decode(data.oci_secrets_secretbundle.nextcloud_db_username.secret_bundle_content.0.content)}
  db-password: ${base64decode(data.oci_secrets_secretbundle.nextcloud_db_password.secret_bundle_content.0.content)}
YAML
}

