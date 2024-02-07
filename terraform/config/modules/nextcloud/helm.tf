resource "helm_release" "nextcloud" {
  chart      = "nextcloud"
  name       = "nextcloud"
  repository = "https://nextcloud.github.io/helm/"
  version    = "4.6.2"
  namespace  = "nextcloud"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 240

  # https://github.com/oracle/oci-cloud-controller-manager/blob/master/docs/load-balancer-annotations.md
  values = [<<YAML
ingress:
  enabled: true
  tls: 
   - secretName: nextcloud-tls
     hosts:
       - nextcloud.achim-winter.eu
  annotations:
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: letsencrypt
    acme.cert-manager.io/http01-edit-in-place: "true"
    kubernetes.io/ingress.class: nginx
    external-dns.alpha.kubernetes.io/hostname: nextcloud.achim-winter.eu
    nginx.ingress.kubernetes.io/proxy-body-size: 3G
    nginx.ingress.kubernetes.io/proxy-buffer-size: 400M
internalDatabase:
  enabled: false
externalDatabase:
  enabled: true
  type: postgresql
  host: postgresql.postgresql.svc.cluster.local
  user: "${base64decode(data.oci_secrets_secretbundle.nextcloud_db_username.secret_bundle_content.0.content)}"
  password: "${base64decode(data.oci_secrets_secretbundle.nextcloud_db_password.secret_bundle_content.0.content)}"
  database: nextcloud
phpClientHttpsFix:
   enabled: true
nextcloud:
  host: nextcloud.achim-winter.eu
  username: "${base64decode(data.oci_secrets_secretbundle.nextcloud_username.secret_bundle_content.0.content)}"
  password: "${base64decode(data.oci_secrets_secretbundle.nextcloud_password.secret_bundle_content.0.content)}"
  configs:
    post_max_size: 5GB
    upload_max_filesize: 4GB
persistence:
  enabled: true
  storageClass: "longhorn"
  size: 20Gi
primary:
  name: main
YAML
  ]

}
