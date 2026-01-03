resource "helm_release" "vaultwarden" {
  chart      = "vaultwarden"
  name       = "vaultwarden"
  repository = "https://charts.gabe565.com"
  version    = "0.16.1"
  namespace  = "vaultwarden"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 1200

  values = [<<YAML
controller:
  strategy: Recreate
env:
  SIGNUPS_ALLOWED: "false"
  INVITATIONS_ALLOWED: "false"
  SHOW_PASSWORD_HINT: "false"
  SHOW_PASSWORD_COUNT: "false"

ingress:
  main:
    enabled: true
    className: traefik
    tls: 
      - secretName: pass-tls
        hosts:
          - pass.winter-achim.de
    hosts:
      - host: pass.winter-achim.de
        paths:
          - path: /
            pathType: Prefix
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt
      external-dns.alpha.kubernetes.io/hostname: pass.winter-achim.de

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
    postgresPassword: "${base64decode(data.oci_secrets_secretbundle.vaultwarden_db_password.secret_bundle_content.0.content)}"
  primary:
    persistence: 
      enabled: true
      storageClass: "longhorn"
      size: 4Gi
YAML
  ]
}