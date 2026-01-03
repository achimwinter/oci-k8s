resource "helm_release" "traefik" {
  chart      = "traefik"
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  version    = "38.0.1"
  namespace  = "traefik"

  create_namespace = true
  atomic           = false
  cleanup_on_fail  = false
  lint             = true
  timeout          = 600

  # https://github.com/oracle/oci-cloud-controller-manager/blob/master/docs/load-balancer-annotations.md
  values = [<<YAML
deployment:
  replicas: 1

# Ports configuration
# Use non-privileged ports for container, service will map to 80/443
# Port 8080 is reserved for traefik dashboard/api
ports:
  web:
    port: 8000
    exposedPort: 80
    expose: 
      default: true
  websecure:
    port: 8443
    exposedPort: 443
    expose: 
      default: true
    tls:
      enabled: true
  metrics:
    port: 9100
    expose: 
      default: false

# Service configuration with OCI LoadBalancer
service:
  enabled: true
  type: LoadBalancer
  annotations:
    service.beta.kubernetes.io/oci-load-balancer-shape: flexible
    service.beta.kubernetes.io/oci-load-balancer-shape-flex-min: "10"
    service.beta.kubernetes.io/oci-load-balancer-shape-flex-max: "10"
    oci.oraclecloud.com/oci-network-security-groups: ${oci_core_network_security_group.traefik_lb.id}

# IngressClass configuration
ingressClass:
  enabled: true
  isDefaultClass: false
  name: traefik

# Enable IngressRoute CRD
ingressRoute:
  dashboard:
    enabled: true
    matchRule: Host(`traefik.winter-achim.de`)
    entryPoints: ["websecure"]
    middlewares:
      - name: dashboard-auth

# Providers
providers:
  kubernetesCRD:
    enabled: true
    allowCrossNamespace: true
  kubernetesIngress:
    enabled: true
    publishedService:
      enabled: true

# Global Arguments
globalArguments:
  - "--global.checknewversion"

# Additional Arguments
additionalArguments:
  - "--metrics.prometheus=true"
  - "--metrics.prometheus.entrypoint=metrics"
  - "--accesslog=true"
  - "--accesslog.format=json"

# Logs
logs:
  general:
    level: INFO
  access:
    enabled: true
    format: json

# Resources
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "300m"
    memory: "256Mi"

# Security Context
securityContext:
  capabilities:
    drop: [ALL]
  readOnlyRootFilesystem: true
  runAsGroup: 65532
  runAsNonRoot: true
  runAsUser: 65532

podSecurityContext:
  fsGroup: 65532
YAML
  ]
}

# Dashboard BasicAuth Middleware
# NOTE: Uncomment this after first apply when Traefik CRDs are installed
# Then run: tofu apply again to create the middleware
#
# resource "kubernetes_manifest" "traefik_dashboard_auth" {
#   manifest = {
#     apiVersion = "traefik.io/v1alpha1"
#     kind       = "Middleware"
#     metadata = {
#       name      = "dashboard-auth"
#       namespace = "traefik"
#     }
#     spec = {
#       basicAuth = {
#         secret = "traefik-dashboard-auth"
#       }
#     }
#   }
#
#   depends_on = [helm_release.traefik]
# }
