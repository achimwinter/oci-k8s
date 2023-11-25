resource "helm_release" "vaultwarden" {
  chart      = "vaultwarden"
  name       = "vaultwarden"
  repository = "https://charts.gabe565.com"
  version    = "0.11.0"
  namespace  = "vaultwarden"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 360

  # https://github.com/oracle/oci-cloud-controller-manager/blob/master/docs/load-balancer-annotations.md
  values = [<<YAML
env:
  ADMIN_TOKEN: ilashdflhaui23hu4rihuf89hvseihf
  DOMAIN: https://pass.achim-winter.eu
ingress:
  main:
    enabled: false
    hosts:
      - host: pass.achim-winter.eu
        paths:
          - path: /
  annotations:
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: letsencrypt
    acme.cert-manager.io/http01-edit-in-place: "true"
    kubernetes.io/ingress.class: nginx
    external-dns.alpha.kubernetes.io/hostname: pass.achim-winter.eu
persistence:
  data:
    enabled: true
    retain: true
    accessMode: ReadWriteOnce
    storageClass: "longhorn"
    size: 1Gi
postgresql:
  enabled: true
  auth:
    database: vaultwarden
    postgresPassword: changeme
  primary:
    persistence: 
      enabled: true
      storageClass: "longhorn"
      size: 4Gi
YAML
  ]
}