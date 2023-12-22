resource "helm_release" "vaultwarden" {
  chart      = "vaultwarden"
  name       = "vaultwarden"
  repository = "https://charts.gabe565.com"
  version    = "0.11.2"
  namespace  = "vaultwarden"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 240

  # ADMIN_TOKEN: "${base64decode(data.oci_secrets_secretbundle.admin_token.secret_bundle_content.0.content)}"
  # https://github.com/oracle/oci-cloud-controller-manager/blob/master/docs/load-balancer-annotations.md
  values = [<<YAML
env:
  SIGNUPS_ALLOWED: "false"
  INVITATIONS_ALLOWED: "false"
  SHOW_PASSWORD_HINT: "false"
  SHOW_PASSWORD_COUNT: "false"
  DOMAIN: "pass.achim-winter.eu"

ingress:
  main:
    enabled: true
    tls: 
    - secretName: pass-tls
      hosts:
        - pass.achim-winter.eu
    hosts:
      - host: pass.achim-winter.eu
        paths:
          - path: /
            pathType: Prefix
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
    postgresPassword: "${random_password.vaultwarden_db_password.result}"
  primary:
    persistence: 
      enabled: true
      storageClass: "longhorn"
      size: 4Gi
YAML
  ]
}
