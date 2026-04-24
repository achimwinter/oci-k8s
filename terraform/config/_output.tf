output "longhorn_login" {
  value = module.longhorn.longhorn_login

  sensitive = true
}

output "argocd_url" {
  value = module.argocd.argocd_server_url
}
