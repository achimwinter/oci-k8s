resource "helm_release" "nextcloud" {
  chart      = "nextcloud"
  name       = "nextcloud"
  repository = "https://nextcloud.github.io/helm/"
  version    = "9.0.6"
  namespace  = "nextcloud"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 1600

  # https://github.com/oracle/oci-cloud-controller-manager/blob/master/docs/load-balancer-annotations.md
  values = [<<YAML
ingress:
  enabled: true
  className: traefik
  tls: 
   - secretName: nextcloud-tls
     hosts:
       - cloud.nexpass.de
  annotations:
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: letsencrypt
    external-dns.alpha.kubernetes.io/hostname: cloud.nexpass.de
internalDatabase:
  enabled: false
externalDatabase:
  enabled: true
  type: postgresql
  host: postgresql-cnpg-rw.postgresql.svc.cluster.local
  user: "${base64decode(data.oci_secrets_secretbundle.nextcloud_db_username.secret_bundle_content.0.content)}"
  password: "${base64decode(data.oci_secrets_secretbundle.nextcloud_db_password.secret_bundle_content.0.content)}"
  database: nextcloud
phpClientHttpsFix:
   enabled: true
nextcloud:
  host: cloud.nexpass.de
  username: "${base64decode(data.oci_secrets_secretbundle.nextcloud_username.secret_bundle_content.0.content)}"
  password: "${base64decode(data.oci_secrets_secretbundle.nextcloud_password.secret_bundle_content.0.content)}"
  configs:
    post_max_size: 5GB
    upload_max_filesize: 4GB
livenessProbe:
  enabled: false
readinessProbe:
  enabled: false
persistence:
  enabled: true
  storageClass: "longhorn"
  size: 10Gi
primary:
  name: main
YAML
  ]

}
