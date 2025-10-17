resource "kubectl_manifest" "postgresql_cnpg_secret" {
  depends_on = [time_sleep.wait_for_cnpg_operator]
  
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: postgresql-cnpg-credentials
  namespace: postgresql
type: kubernetes.io/basic-auth
data:
  username: ${base64encode(base64decode(data.oci_secrets_secretbundle.nextcloud_db_username.secret_bundle_content.0.content))}
  password: ${base64encode(base64decode(data.oci_secrets_secretbundle.nextcloud_db_password.secret_bundle_content.0.content))}
YAML
}

resource "kubectl_manifest" "postgresql_cnpg_cluster" {
  depends_on = [
    kubectl_manifest.postgresql_cnpg_secret,
    time_sleep.wait_for_cnpg_operator
  ]
  
  yaml_body = <<YAML
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: postgresql-cnpg
  namespace: postgresql
spec:
  # Cluster Configuration
  instances: 1
  primaryUpdateStrategy: unsupervised
  
  # PostgreSQL Configuration
  postgresql:
    parameters:
      # Performance
      max_connections: "200"
      shared_buffers: "256MB"
      effective_cache_size: "1GB"
      maintenance_work_mem: "64MB"
      checkpoint_completion_target: "0.7"
      wal_buffers: "16MB"
      default_statistics_target: "100"
      random_page_cost: "1.1"  # SSD optimized
      
      # Logging and Monitoring
      log_checkpoints: "on"
      log_connections: "on"
      log_disconnections: "on"
      log_lock_waits: "on"
      log_temp_files: "0"
      
      # Replication (für Migration)
      wal_level: "logical"
      max_wal_senders: "10"
      max_replication_slots: "10"
      max_logical_replication_workers: "4"
  
  # Bootstrap from existing database
  bootstrap:
    initdb:
      database: nextcloud
      owner: ${base64decode(data.oci_secrets_secretbundle.nextcloud_db_username.secret_bundle_content.0.content)}
      secret:
        name: postgresql-cnpg-credentials
      
      # Init SQL für Nextcloud Setup
      postInitSQL:
        - "CREATE EXTENSION IF NOT EXISTS plpgsql;"
        - "ALTER USER ${base64decode(data.oci_secrets_secretbundle.nextcloud_db_username.secret_bundle_content.0.content)} CREATEDB;"
        # - "GRANT ALL PRIVILEGES ON DATABASE nextcloud TO ${base64decode(data.oci_secrets_secretbundle.nextcloud_db_username.secret_bundle_content.0.content)};"
  
  # Storage Configuration
  storage:
    size: 20Gi
    storageClass: longhorn
    resizeInUseVolumes: true
  
  # Resources
  resources:
    requests:
      memory: "512Mi"
      cpu: "500m"
    limits:
      memory: "1Gi"
      cpu: "1"
  
  # Monitoring
  monitoring:
    enabled: true
    podMonitorSelector:
      matchLabels:
        postgresql: cnpg
        
  # Affinity for HA
  affinity:
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              postgresql: cnpg
          topologyKey: kubernetes.io/hostname
YAML
}


resource "kubectl_manifest" "postgresql_cnpg_service" {
  depends_on = [kubectl_manifest.postgresql_cnpg_cluster]
  
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: postgresql-cnpg-rw
  namespace: postgresql
  labels:
    app: postgresql-cnpg
spec:
  type: ClusterIP
  ports:
  - name: postgresql
    port: 5432
    targetPort: 5432
    protocol: TCP
  selector:
    postgresql: cnpg
    role: primary
YAML
}