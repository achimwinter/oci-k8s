resource "helm_release" "vaultwarden" {
  chart      = "vaultwarden"
  name       = "vaultwarden"
  repository = "https://guerzon.github.io/vaultwarden"
  version    = "0.34.6"
  namespace  = "vaultwarden"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 1200

  values = [<<YAML
domain: "https://pass.winter-achim.de"

signupsAllowed: false
invitationsAllowed: false
showPassHint: "false"

adminToken:
  value: "${base64decode(data.oci_secrets_secretbundle.admin_token.secret_bundle_content.0.content)}"

database:
  type: "postgresql"
  host: "postgresql-cnpg-rw.postgresql.svc.cluster.local"
  dbName: "vaultwarden"
  username: "vaultwarden"
  password: "${base64decode(data.oci_secrets_secretbundle.vaultwarden_db_password.secret_bundle_content.0.content)}"

storage:
  data:
    name: "vaultwarden-data"
    size: "1Gi"
    class: "longhorn"
    accessMode: "ReadWriteOnce"
    keepPvc: true

ingress:
  enabled: true
  class: traefik
  nginxIngressAnnotations: false
  hostname: pass.winter-achim.de
  tls: true
  tlsSecret: pass-tls
  additionalAnnotations:
    cert-manager.io/cluster-issuer: letsencrypt
    external-dns.alpha.kubernetes.io/hostname: pass.winter-achim.de
YAML
  ]
}