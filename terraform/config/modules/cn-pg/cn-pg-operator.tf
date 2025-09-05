resource "helm_release" "cloudnative_pg" {
  chart      = "cloudnative-pg"
  name       = "cloudnative-pg"
  repository = "https://cloudnative-pg.github.io/charts"
  version    = "0.26.0"
  namespace  = "cn-pg"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 300

  # https://github.com/oracle/oci-cloud-controller-manager/blob/master/docs/load-balancer-annotations.md
values = [<<YAML
# CloudNativePG Operator Configuration
replicaCount: 1

image:
  repository: ghcr.io/cloudnative-pg/cloudnative-pg
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 100m
    memory: 200Mi
  requests:
    cpu: 100m
    memory: 100Mi

# Monitoring
monitoring:
  enabled: true
  createPodMonitor: true

# Webhook Configuration
webhook:
  port: 9443
  mutating:
    create: true
  validating:
    create: true

# RBAC
rbac:
  create: true
  aggregateClusterRoles: false

config:
  # Logging
  logLevel: "info"
  # Operator configuration
  data:
    INHERITED_ANNOTATIONS: "service.beta.kubernetes.io/oci-load-balancer-shape"
    INHERITED_LABELS: "app.kubernetes.io/name,app.kubernetes.io/instance"
YAML
  ]
}

# Wait for operator to be ready
resource "time_sleep" "wait_for_cnpg_operator" {
  depends_on = [helm_release.cloudnative_pg]
  create_duration = "60s"
}