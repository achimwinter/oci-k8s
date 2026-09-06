resource "helm_release" "external_secrets" {
  chart      = "external-secrets"
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  version    = "2.10.0"
  namespace  = "external-secrets"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 300
}
