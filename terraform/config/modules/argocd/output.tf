output "argocd_server_url" {
  description = "Argo CD server URL"
  value       = "https://${var.argocd_hostname}"
}

