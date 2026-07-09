module "longhorn" {
  source = "./modules/longhorn"

  compartment_id = var.compartment_id
  vault_id       = var.vault_id
}

module "traefik" {
  source = "./modules/traefik"

  compartment_id = var.compartment_id
}

module "cert-manager" {
  source = "./modules/cert-manager"
}

module "cn-postgres" {
  source = "./modules/cn-pg"

  compartment_id = var.compartment_id
}

module "external-secrets" {
  source = "./modules/external-secrets"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid
  vault_id       = var.vault_id
  region         = var.region
}

module "app-secrets" {
  source = "./modules/app-secrets"

  cluster_secret_store_name = module.external-secrets.cluster_secret_store_name
}

module "argocd" {
  source = "./modules/argocd"

  gitops_repo_url      = var.gitops_repo_url
  gitops_repo_revision = var.gitops_repo_revision
  gitops_apps_path     = var.gitops_apps_path
  argocd_hostname      = var.argocd_hostname
}
