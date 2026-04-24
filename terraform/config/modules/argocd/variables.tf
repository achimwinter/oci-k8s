variable "gitops_repo_url" {
  description = "Git repository URL that Argo CD should sync from"
  type        = string
}

variable "gitops_repo_revision" {
  description = "Git revision Argo CD should track"
  type        = string
}

variable "gitops_apps_path" {
  description = "Path in the Git repository containing Argo CD application manifests"
  type        = string
}

variable "argocd_hostname" {
  description = "Public hostname for Argo CD ingress"
  type        = string
}

