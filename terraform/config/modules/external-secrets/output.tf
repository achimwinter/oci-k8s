output "cluster_secret_store_name" {
  description = "Name of the ClusterSecretStore backed by OCI Vault"
  value       = "oci-vault"

  depends_on = [kubectl_manifest.oci_vault_cluster_secret_store]
}
