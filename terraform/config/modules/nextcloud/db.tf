# resource "helm_release" "postgresql" {
#   chart      = "postgresql"
#   name       = "postgresql"
#   repository = "https://charts.bitnami.com/bitnami"
#   version    = "13.1.5"
#   namespace  = "nextcloud"

#   create_namespace = true
#   atomic           = true
#   cleanup_on_fail  = true
#   lint             = true
#   timeout          = 120

#   # https://github.com/oracle/oci-cloud-controller-manager/blob/master/docs/load-balancer-annotations.md
#   values = [<<YAML
# global:
#   storageClass: "longhorn"
#   size: "20Gi"
#   postgresql:
#     auth:
#         username: "${base64decode(data.oci_secrets_secretbundle.nextcloud_db_username.secret_bundle_content.0.content)}"
#         password: "${base64decode(data.oci_secrets_secretbundle.nextcloud_db_password.secret_bundle_content.0.content)}"
#         database: "nextcloud"
# ingressRules:
#   primaryAccessOnlyFrom:
#     enabled: true
#     namespaceSelector: nextcloud
# networkPolicy:
#   enabled: true
#   ingress:
#     - from:
#       - namespaceSelector:
#           matchLabels:
#             name: nextcloud

# YAML
#   ]

# }