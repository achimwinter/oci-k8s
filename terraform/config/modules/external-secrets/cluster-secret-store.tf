resource "kubectl_manifest" "oci_vault_cluster_secret_store" {
  depends_on = [
    helm_release.external_secrets,
    oci_identity_policy.external_secrets_vault_read
  ]

  yaml_body = <<YAML
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: oci-vault
spec:
  provider:
    oracle:
      vault: ${var.vault_id}
      region: ${var.region}
      principalType: InstancePrincipal
YAML
}
