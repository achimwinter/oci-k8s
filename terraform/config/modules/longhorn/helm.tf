resource "helm_release" "longhorn" {
  chart      = "longhorn"
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  version    = "1.5.1"
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
  tls: true
  host: storage.achim-winter.eu
  tlsSecret: longhorn-cert
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    acme.cert-manager.io/http01-edit-in-place: "true"
    kubernetes.io/ingress.class: traefik
    external-dns.alpha.kubernetes.io/hostname: storage.achim-winter.eu
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.middlewares: longhorn-middleware@kubernetescrd
YAML
  ]

  depends_on = [
    kubectl_manifest.longhorn_ui
  ]
}
