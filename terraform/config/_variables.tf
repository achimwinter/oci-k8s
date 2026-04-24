variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
}

variable "region" {
  description = "OCI region"
  type        = string

  default = "eu-frankfurt-1"
}

variable "public_subnet_id" {
  type        = string
  description = "The public subnet's OCID"
}

variable "node_pool_id" {
  description = "The OCID of the Node Pool where the compute instances reside"
  type        = string
}

variable "vault_id" {
  description = "OCI Vault OIDC"
  type        = string
}

variable "gitops_repo_url" {
  description = "Git repository URL that Argo CD should sync from"
  type        = string
  default     = "https://github.com/achimwinter/oci-k8s.git"
}

variable "gitops_repo_revision" {
  description = "Git revision Argo CD should track"
  type        = string
  default     = "main"
}

variable "gitops_apps_path" {
  description = "Path in the Git repository containing Argo CD application manifests"
  type        = string
  default     = "gitops/argocd/apps"
}

variable "argocd_hostname" {
  description = "Public hostname for the Argo CD server ingress"
  type        = string
  default     = "argocd.winter-achim.de"
}
