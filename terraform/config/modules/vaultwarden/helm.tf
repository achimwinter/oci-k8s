resource "helm_release" "vaultwarden" {
  chart      = "vaultwarden"
  name       = "vaultwarden"
  repository = "https://charts.gabe565.com"
  version    = "0.15.1"
  namespace  = "vaultwarden"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 1200

  # https://github.com/oracle/oci-cloud-controller-manager/blob/master/docs/load-balancer-annotations.md
  # ADMIN_TOKEN: "${base64decode(data.oci_secrets_secretbundle.admin_token.secret_bundle_content.0.content)}"
  values = [<<YAML
controller:
  strategy: Recreate
env:
  SIGNUPS_ALLOWED: "true"
  INVITATIONS_ALLOWED: "false"
  SHOW_PASSWORD_HINT: "false"
  SHOW_PASSWORD_COUNT: "false"

ingress:
  main:
    enabled: true
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
      kubernetes.io/tls-acme: "true"
      cert-manager.io/cluster-issuer: letsencrypt
      acme.cert-manager.io/http01-edit-in-place: "true"
      kubernetes.io/ingress.class: nginx
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
