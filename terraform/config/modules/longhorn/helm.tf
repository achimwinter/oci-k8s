resource "helm_release" "longhorn" {
  chart      = "longhorn"
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  version    = "1.9.1"
  namespace  = "longhorn-system"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 110

  values = [<<YAML
defaultSettings:
  storageMinimalAvailablePercentage: 10
persistence:
  defaultClassReplicaCount: 2
ingress:
  enabled: true
  ingressClassName: nginx
  tls: true
  host: storage.winter-achim.de
  tlsSecret: longhorn-cert
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    external-dns.alpha.kubernetes.io/hostname: storage.winter-achim.de
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: basic-auth
    nginx.ingress.kubernetes.io/auth-realm: "Enter your credentials"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
YAML
  ]

  depends_on = [
    kubectl_manifest.longhorn_ui
  ]
}
