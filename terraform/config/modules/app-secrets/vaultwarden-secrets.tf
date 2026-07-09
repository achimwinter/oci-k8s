resource "kubectl_manifest" "vaultwarden_db_credentials" {
  depends_on = [kubectl_manifest.vaultwarden_namespace]

  # The database username is a fixed, non-secret value (matching the
  # database owner role created by the cn-pg module), only the password
  # is pulled from OCI Vault.
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: vaultwarden-db-credentials
  namespace: vaultwarden
spec:
  refreshInterval: 1h
  secretStoreRef:
    kind: ClusterSecretStore
    name: ${var.cluster_secret_store_name}
  target:
    name: vaultwarden-db-credentials
    creationPolicy: Owner
    template:
      data:
        username: vaultwarden
        password: "{{ .password }}"
  data:
    - secretKey: password
      remoteRef:
        key: ${data.oci_vault_secret.vaultwarden_db_password.secret_name}
YAML
}

resource "kubectl_manifest" "vaultwarden_admin_token" {
  depends_on = [kubectl_manifest.vaultwarden_namespace]

  yaml_body = <<YAML
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: vaultwarden-admin-token
  namespace: vaultwarden
spec:
  refreshInterval: 1h
  secretStoreRef:
    kind: ClusterSecretStore
    name: ${var.cluster_secret_store_name}
  target:
    name: vaultwarden-admin-token
    creationPolicy: Owner
  data:
    - secretKey: ADMIN_TOKEN
      remoteRef:
        key: ${data.oci_vault_secret.vaultwarden_admin_token.secret_name}
YAML
}

