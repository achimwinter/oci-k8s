# Traefik Ingress Controller Module

Dieses Modul installiert Traefik als Ingress Controller auf deinem OKE-Cluster mit OCI LoadBalancer Integration.

## Features

- ✅ **OCI LoadBalancer** mit Flexible Shape (10 Mbps)
- ✅ **Network Security Groups** für HTTP/HTTPS Traffic
- ✅ **2 Replicas** für High Availability
- ✅ **Dashboard** mit BasicAuth (optional)
- ✅ **Prometheus Metrics** auf Port 9100
- ✅ **JSON Access Logs** für bessere Auswertbarkeit
- ✅ **IngressRoute & Middleware CRDs** aktiviert
- ✅ **TLS/HTTPS** Support out-of-the-box

## Verwendung

```terraform
module "traefik" {
  source = "./modules/traefik"

  compartment_id = var.compartment_id
  
  # Optional
  dashboard_enabled = true
  dashboard_host    = "traefik.winter-achim.de"
  replica_count     = 2
  lb_shape_min      = "10"
  lb_shape_max      = "10"
}
```

## Voraussetzungen

- Kubernetes Cluster (OKE)
- Helm Provider konfiguriert
- Kubernetes Provider konfiguriert
- OCI Provider konfiguriert

## Dashboard Zugriff

Das Traefik Dashboard ist unter `traefik.winter-achim.de` erreichbar (wenn aktiviert).

**BasicAuth Secret erstellen:**
```bash
# Passwort generieren (htpasswd)
htpasswd -nb admin <password> | base64

# Secret erstellen
kubectl create secret generic traefik-dashboard-auth \
  --from-literal=users='<base64-encoded-credentials>' \
  -n traefik
```

## Ingress Beispiele

### Standard Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
spec:
  ingressClassName: traefik
  rules:
    - host: app.winter-achim.de
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app
                port:
                  number: 80
  tls:
    - secretName: my-app-tls
      hosts:
        - app.winter-achim.de
```

### Mit Middleware (BasicAuth)

```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: basic-auth
  namespace: my-namespace
spec:
  basicAuth:
    secret: my-basic-auth-secret
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  annotations:
    traefik.ingress.kubernetes.io/router.middlewares: my-namespace-basic-auth@kubernetescrd
spec:
  ingressClassName: traefik
  # ... rest of config
```

## Wichtige Middlewares

### Body Size Limit (für große Uploads)

```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: body-size-limit
spec:
  buffering:
    maxRequestBodyBytes: 3221225472  # 3GB
```

### CORS Headers

```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: cors-headers
spec:
  headers:
    accessControlAllowOriginList:
      - "*"
    accessControlAllowHeaders:
      - "X-Forwarded-For"
```

## LoadBalancer IP abrufen

```bash
kubectl get svc -n traefik traefik -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

## Monitoring

Prometheus Metrics sind verfügbar unter:
- Port: `9100`
- Path: `/metrics`

## Migration von nginx-ingress

Siehe Hauptdokumentation für detaillierte Migrationsschritte.

**Wichtigste Änderungen:**
- `ingressClassName: nginx` → `ingressClassName: traefik`
- Annotations verwenden `traefik.ingress.kubernetes.io/*` statt `nginx.ingress.kubernetes.io/*`
- Komplexe Features als Middleware CRDs definieren

## Outputs

- `traefik_namespace` - Namespace von Traefik
- `traefik_service_name` - Service Name
- `traefik_chart_version` - Helm Chart Version
- `security_group_id` - OCI Network Security Group ID
- `security_group_name` - OCI Network Security Group Name
