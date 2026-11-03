# :cloud: Oracle Cloud kubernetes free tier setup

This repo utilizes the [always free tier](https://blogs.oracle.com/cloud-infrastructure/post/oracle-builds-out-their-portfolio-of-oracle-cloud-infrastructure-always-free-services) of the oracle cloud to provision a kubernetes cluster.

At orcale cloud the Kubernetes controlplane (oke) is free to use, you just pay
for the workers, *if* you surpass the always free tier (which we don't).
You get 4 oCpus and 24GB memory which are split into two worker-instances
(`VM.Standard.A1.Flex` -> arm), allowing good resource utilization.
The boot partions are 100Gb each, allowing `longhorn` to use around 60GB as in
cluster storage. For the ingress class we use `traefik` with the oracle Flexible 
LB (10Mbps), because that's free as well.

> :warning: This project uses arm instances, no x86 architecture

## :wrench: Tooling
- [x] K8s control plane
- [x] Worker Nodes
- [x] Ingress  
  traefik
- [x] Storage  
  with longhorn
- [x] GitOps  
  argo cd (apps)

## :keyboard: Setup

This setup uses terraform to managed the oci and kubernetes part.

The terraform state is pushed to the oracle object storage (free as well). For that
we have to create a bucket initially:
```
$ oci os bucket create --name terraform-states --versioning Enabled --compartment-id xxx
```

* The infrastructure (everything to a usable k8s-api endpoint) is managed by
terrafom in [infra](infra/)
* The cluster base modules (traefik, cert-manager, longhorn, cnpg, argocd bootstrap) are managed by terraform in [config](config/)
* Applications are managed by Argo CD from [`gitops/argocd/apps`](gitops/argocd/apps)

These components are independed from eachother, but obv. the infra should
be created first.

### GitOps split (Terraform vs Argo CD)
* **Terraform** provisions platform components (networking/infra, ingress, storage, cert-manager, cnpg, argocd bootstrap).
* **Argo CD** deploys and reconciles apps (currently Nextcloud + Vaultwarden).
* New services like Grafana or VPN should be added as Argo-CD Applications by default.

FluxCD is intentionally not the default in this repository to keep one GitOps control plane.

For the config part, we need to add a private `*.tfvars` file:
```
node_pool_id     = "ocid1.nodepool.xxx"
public_subnet_id = "ocid1.subnet.yyy"
compartment_id   = "ocid1.tenancy.zzz"
vault_id         = "ocid1.vault.aaa"
```

* The first & second value are outputs from the infra-terraform.
* The third & fourth value are currently extracted from the webui

### kubeconfig
With the following command we get the kubeconfig for terraform/direct access:
```
# in the infra folder
oci ce cluster create-kubeconfig --cluster-id $(terraform output --raw k8s_cluster_id) --file ~/.kube/configs/oci.kubeconfig --region eu-frankfurt-1 --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT
```

## :telescope: renovate maintenance 
This repo utilizes renovate to update all terraform providers and helm charts.

The helm chart versions need to be stored alongside the repository info, and
not in tf variables. Using variables might be possible, but quite ugly.
* https://github.com/renovatebot/renovate/discussions/16052

### Security updates and rebuilt images

Nextcloud and Vaultwarden use the image version supplied by their Helm charts and
`image.pullPolicy: Always`. This lets replacement pods pick up security rebuilds
published under the same image tag. A new image publication does not update an
already running container. After checking the new build, replace the pod with:

```sh
kubectl -n nextcloud rollout restart deployment/nextcloud
kubectl -n nextcloud rollout status deployment/nextcloud --timeout=10m
kubectl -n nextcloud exec deployment/nextcloud -- php -v
kubectl -n nextcloud exec deployment/nextcloud -- \
  dpkg-query -W '-f=${Package} ${Version} source=${source:Version}\n' libbrotli1
```

Check the distribution's security tracker for patched package versions:
upstream library versions alone do not account for Debian security backports.
For [CVE-2026-111497](https://security-tracker.debian.org/tracker/CVE-2026-111497),
Debian Trixie's Brotli fix is `1.1.0-2+deb13u1`; `1.1.0-2+b7` does not contain it.
The [Traefik chart](terraform/config/modules/traefik/helm.tf) must also be updated
for application security releases; chart 42.3.0 ships Traefik 3.7.17.

Argo CD reconciles application configuration from `main`. Publish changes to
[the Nextcloud Application](gitops/argocd/apps/nextcloud.yaml) before relying on
them; manual deployment edits can be reverted by self-healing.

Container image updates do not patch the worker-node kernel. Updating the OKE
node-pool version or source image also does not update existing nodes in place.
Check both control-plane and worker versions, and plan node maintenance
separately. [The node-pool configuration](terraform/infra/k8s.tf) selects the
newest date-stamped Oracle Linux 8.10 ARM64 image for the exact Kubernetes
version. It does not depend on API result ordering or silently switch to Oracle
Linux 9. An OKE image can still lag behind
[Oracle's kernel security updates](https://linux.oracle.com/errata/). Compare the
running kernel with the current vendor packages after provisioning; installing
a newer kernel is not sufficient until a controlled reboot activates it.
Before rebooting or replacing a node:

* Verify recoverable database and file backups. Device synchronization is not
  an independent Nextcloud backup, and a Vaultwarden JSON export does not
  necessarily include attachments.
* Check Longhorn volume/replica health and PodDisruptionBudgets. This cluster has
  two workers and a single PostgreSQL instance; maintenance can interrupt apps.
* Inspect existing PV `spec.nodeAffinity` before replacing workers. Legacy
  Longhorn PVs can still name retired nodes even though the replicated data is
  available elsewhere. This OKE API does not allow editing that affinity.
  Correct retained PV/PVC bindings while preserving their Longhorn volume IDs;
  never delete the backing data volumes as part of a metadata repair.
* Follow the supported OKE and Longhorn maintenance procedures, one node at a
  time. Do not force-delete pods, bypass disruption budgets, or delete a worker's
  boot volume while it still contains required Longhorn replicas.
* For planned downtime of the single PostgreSQL instance, use CloudNativePG's
  documented maintenance controls with PVC reuse. Restore the original
  maintenance settings and verify that the operator recreates its disruption
  budget after the database is ready again.
* Verify the running kernel (or proven livepatch coverage), node readiness,
  healthy volumes and application availability after each node.

The PostgreSQL operand image is pinned separately in the
[CloudNativePG cluster](terraform/config/modules/cn-pg/cn-pg-cluster.tf). Updating
the operator alone does not update an existing cluster's PostgreSQL image.
Select a current ARM64 build from the
[official system-trixie catalog](https://github.com/cloudnative-pg/artifacts/blob/main/image-catalogs/catalog-system-trixie.yaml),
retain the database major version, scan its digest, and explicitly update
`imageName`. The single-instance rollout briefly interrupts database clients.
Docker updates are currently disabled in Renovate, so this pin requires manual
review.

A CVE scan must cover the running image digests, init containers, host package
inventories, and Longhorn's **volume engine** versions. Updating the Longhorn
chart does not necessarily upgrade engines already serving volumes. Follow the
[supported engine procedure](https://longhorn.io/docs/1.13.0/deploy/upgrade/upgrade-engine/)
with verified backups; do not jump unsupported live-upgrade paths.
For older V1 engines, a controlled offline path through each intermediate minor
release avoids unsupported live jumps (for example 1.11 -> 1.12 -> 1.13).
Before detaching application volumes, temporarily pause Argo CD reconciliation
(including the parent application), stop the clients, and use CloudNativePG's
[declarative hibernation](https://cloudnative-pg.io/docs/1.30/declarative_hibernation/)
to stop PostgreSQL while retaining its PVC. Back up files, database contents and
restoration metadata to storage independent of the workers; test the SQL restore,
archive integrity and checksums before changing engines. Such backups contain
private files and credentials and must never be committed. After each engine
step, reattach and verify all replicas before continuing. Finally remove the
hibernation annotation, disable Nextcloud maintenance mode and restore all
temporary reconciliation settings.
Keep raw scanner reports and distinguish package/CVE matches, vendor backports,
inactive installed kernels, and reachable application vulnerabilities. A latest
chart or a successful rollout is not evidence that all bundled CVEs are fixed.
