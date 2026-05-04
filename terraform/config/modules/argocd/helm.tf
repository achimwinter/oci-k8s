resource "helm_release" "argocd" {
  chart      = "argo-cd"
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "9.5.11"
  namespace  = "argocd"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 900

values = [<<YAML
global:
  domain: ${var.argocd_hostname}
configs:
  params:
    server.insecure: true
server:
  ingress:
    enabled: true
    ingressClassName: traefik
    hostname: ${var.argocd_hostname}
    tls: true
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt
      external-dns.alpha.kubernetes.io/hostname: ${var.argocd_hostname}
YAML
  ]
}
