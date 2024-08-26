module "longhorn" {
  source = "./modules/longhorn"

  compartment_id = var.compartment_id
  vault_id       = var.vault_id
}

module "ingress" {
  source = "./modules/nginx-ingress"

  compartment_id = var.compartment_id
}

module "cert-manager" {
  source = "./modules/cert-manager"
}

module "postgres" {
  source = "./modules/postgres"

  compartment_id = var.compartment_id
}

module "nextcloud" {
  source = "./modules/nextcloud"

  compartment_id = var.compartment_id
}

# module "jmusicbot" {
#   source = "./modules/jmusicbot"

#   compartment_id = var.compartment_id
#   vault_id       = var.vault_id
# }

module "vaultwarden" {
  source = "./modules/vaultwarden"

  compartment_id = var.compartment_id
}
