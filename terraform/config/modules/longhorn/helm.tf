resource "helm_release" "longhorn" {
  chart      = "longhorn"
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  version    = "1.10.1"
  namespace  = "longhorn-system"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 110

  values = [<<YAML
defaultSettings:
  storageMinimalAvailablePercentage: "10"
persistence:
  defaultClassReplicaCount: 2
ingress:
  enabled: true
  ingressClassName: traefik
  tls: true
  host: storage.winter-achim.de
  tlsSecret: longhorn-cert
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    external-dns.alpha.kubernetes.io/hostname: storage.winter-achim.de
    traefik.ingress.kubernetes.io/router.middlewares: longhorn-system-longhorn-auth@kubernetescrd
YAML
  ]

  depends_on = [
    kubectl_manifest.longhorn_ui
  ]
}
