resource "helm_release" "palworld" {
  chart      = "palworld"
  name       = "palworld"
  repository = "https://twinki14.github.io/palworld-server-chart"
  version    = "0.30.1"
  namespace  = "palworld"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 300

  values = [<<YAML
  server:
  annotations: {}
  labels: {}
  resources:
    limits:
      cpu: 2
      memory: "10Gi"
    requests:
      cpu: 2
      memory: "8Gi"
  storage:
    main:
      external: true
      externalName: "palworld"
      preventDelete: true
      size: 12Gi
      storageClassName: "longhorn"
YAML
  ]
}
