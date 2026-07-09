variable "cluster_secret_store_name" {
  description = "Name of the ClusterSecretStore used to fetch secrets from OCI Vault"
  type        = string
  default     = "oci-vault"
}
