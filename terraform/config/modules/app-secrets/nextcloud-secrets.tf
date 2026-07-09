resource "kubectl_manifest" "nextcloud_credentials" {
  depends_on = [kubectl_manifest.nextcloud_namespace]

  yaml_body = <<YAML
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: nextcloud-credentials
  namespace: nextcloud
spec:
  refreshInterval: 1h
  secretStoreRef:
    kind: ClusterSecretStore
    name: ${var.cluster_secret_store_name}
  target:
    name: nextcloud-credentials
    creationPolicy: Owner
  data:
    - secretKey: nextcloud-username
      remoteRef:
        key: ${data.oci_vault_secret.nextcloud_username.secret_name}
    - secretKey: nextcloud-password
      remoteRef:
        key: ${data.oci_vault_secret.nextcloud_password.secret_name}
    - secretKey: db-username
      remoteRef:
        key: ${data.oci_vault_secret.nextcloud_db_username.secret_name}
    - secretKey: db-password
      remoteRef:
        key: ${data.oci_vault_secret.nextcloud_db_password.secret_name}
YAML
}

